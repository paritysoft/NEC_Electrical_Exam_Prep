"""Validate the built Store package, using only the Python standard library."""

import base64
import hashlib
import sys
import xml.etree.ElementTree as ET
import zipfile

NAME = 'ParisoftAI.ElectricianExamPrepNEC'
PUBLISHER = 'CN=BAFD5734-F723-4C9B-9352-3ED618975B07'
FAMILY = NAME + '_pxzj9qxns246m'
NS = {'m': 'http://schemas.microsoft.com/appx/manifest/foundation/windows10'}


def validate(path, version):
    errors = []

    def check(actual, expected, label):
        if actual != expected:
            errors.append(f'{label}: expected {expected!r}, got {actual!r}')

    with zipfile.ZipFile(path) as package:
        manifest = ET.fromstring(package.read('AppxManifest.xml'))
        identity = manifest.find('m:Identity', NS)
        if identity is None:
            raise ValueError('Package has no Identity element')
        check(identity.get('Name'), NAME, 'Identity name')
        publisher = identity.get('Publisher', '')
        check(publisher, PUBLISHER, 'Publisher')
        # Windows publisher ID: first 64 SHA-256 bits of the UTF-16LE subject,
        # encoded using the Windows base32 alphabet.
        digest = hashlib.sha256(publisher.encode('utf-16le')).digest()[:8]
        alphabet = str.maketrans('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567',
                                '0123456789abcdefghjkmnpqrstvwxyz')
        publisher_id = base64.b32encode(digest).decode().rstrip('=').translate(alphabet)
        check(identity.get('Name', '') + '_' + publisher_id, FAMILY, 'Package family')
        check(identity.get('Version'), version, 'Version')
        parts = version.split('.')
        if (len(parts) != 4 or not all(p.isdigit() for p in parts)
                or any(int(p) > 65535 for p in parts)
                or int(parts[0]) == 0 or parts[-1] != '0'):
            errors.append('Store version must be major.minor.patch.0, with components <= 65535')
        check(identity.get('ProcessorArchitecture'), 'x64', 'Architecture')
        check(manifest.findtext('m:Properties/m:PublisherDisplayName', namespaces=NS),
              'ParisoftAI', 'Publisher display name')
        check(manifest.findtext('m:Properties/m:DisplayName', namespaces=NS),
              'Electrician Exam Prep: NEC', 'App display name')
        families = manifest.findall('m:Dependencies/m:TargetDeviceFamily', NS)
        check([f.get('Name') for f in families], ['Windows.Desktop'], 'Device families')
        files = {name.replace('\\', '/').lower() for name in package.namelist()}
        required = ['flutter_windows.dll', 'data/icudtl.dat', 'data/app.so',
                    'data/flutter_assets/.env', 'AppxBlockMap.xml', '[Content_Types].xml']
        apps = manifest.findall('m:Applications/m:Application', NS)
        if not apps:
            errors.append('No application declared')
        for app in apps:
            required.append(app.get('Executable', ''))
        for node in manifest.iter():
            if node.tag.rsplit('}', 1)[-1] == 'Logo' and node.text:
                required.append(node.text)
            for key, value in node.attrib.items():
                if key.endswith('Logo') or key == 'Image':
                    required.append(value)
        for name in required:
            if not name or name.replace('\\', '/').lower() not in files:
                errors.append(f'Missing package file: {name}')
        capabilities = {node.get('Name') for node in manifest.findall('m:Capabilities/*', NS)}
        if not {'internetClient', 'runFullTrust'} <= capabilities:
            errors.append('Missing internetClient or runFullTrust capability')
    if errors:
        raise ValueError('\n'.join(errors))


if __name__ == '__main__':
    try:
        validate(sys.argv[1], sys.argv[2])
    except (OSError, ValueError, KeyError, ET.ParseError, zipfile.BadZipFile) as error:
        sys.exit(f'MSIX validation failed:\n{error}')
    print(f'MSIX validation passed: {FAMILY}, version {sys.argv[2]}')
