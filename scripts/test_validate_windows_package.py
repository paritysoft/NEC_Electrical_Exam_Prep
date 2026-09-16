import tempfile
import unittest
from pathlib import Path
from zipfile import ZipFile

from validate_windows_package import NAME, NS, PUBLISHER, validate


class PackageValidationTests(unittest.TestCase):
    def make_package(self, folder, *, qualified=True, pri=True, missing=None,
                     publisher=PUBLISHER):
        images = ['StoreLogo', 'Square150x150Logo', 'Square44x44Logo',
                  'LargeTile', 'SmallTile', 'Wide310x150Logo', 'SplashScreen', 'BadgeLogo']
        logos = ''.join(f'<Logo>Images\\{name}.png</Logo>' for name in images)
        manifest = f'''<Package xmlns="{NS['m']}">
          <Identity Name="{NAME}" Publisher="{publisher}" Version="1.0.3.0"
                    ProcessorArchitecture="x64"/>
          <Properties><DisplayName>Electrician Exam Prep: NEC</DisplayName>
            <PublisherDisplayName>ParisoftAI</PublisherDisplayName>{logos}</Properties>
          <Dependencies><TargetDeviceFamily Name="Windows.Desktop"/></Dependencies>
          <Capabilities><Capability Name="internetClient"/>
            <Capability Name="runFullTrust"/></Capabilities>
          <Applications><Application Executable="commonquiz.exe"/></Applications>
        </Package>'''
        files = ['commonquiz.exe', 'flutter_windows.dll', 'data/icudtl.dat',
                 'data/app.so', 'data/flutter_assets/.env', 'AppxBlockMap.xml',
                 '[Content_Types].xml']
        if pri:
            files.append('resources.pri')
        suffix = '.scale-100' if qualified else ''
        files.extend(f'Images/{name}{suffix}.png' for name in images)
        path = Path(folder) / 'fixture.msix'
        with ZipFile(path, 'w') as package:
            package.writestr('AppxManifest.xml', manifest)
            for name in files:
                if name != missing:
                    package.writestr(name, b'fixture')
        return path

    def test_literal_and_scaled_images(self):
        for qualified in (False, True):
            with self.subTest(qualified=qualified), tempfile.TemporaryDirectory() as folder:
                validate(self.make_package(folder, qualified=qualified), '1.0.3.0')

    def test_missing_resources_and_wrong_identity_fail(self):
        cases = [({'missing': 'Images/StoreLogo.scale-100.png'}, 'StoreLogo'),
                 ({'pri': False}, 'image resource'),
                 ({'missing': 'commonquiz.exe'}, 'commonquiz.exe'),
                 ({'missing': 'data/flutter_assets/.env'}, '.env'),
                 ({'publisher': 'CN=ElectricianExamPrep'}, 'Publisher')]
        for options, message in cases:
            with self.subTest(options=options), tempfile.TemporaryDirectory() as folder:
                with self.assertRaisesRegex(ValueError, message):
                    validate(self.make_package(folder, **options), '1.0.3.0')


if __name__ == '__main__':
    unittest.main()
