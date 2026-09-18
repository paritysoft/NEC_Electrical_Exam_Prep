# commonquiz

The quiz can be designed to be challenging but accessible to participants of all backgrounds, providing a fun and engaging way to learn new facts and refresh one's memory on known topics. Common quizzes are often used in schools, workplace training, quiz games, and community events to encourage learning and collaboration.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Windows build

The Windows app is named **Electrician Exam Prep: NEC**. There is one app,
with no flavors or build variants.

The **Windows Build** GitHub Actions workflow runs on pushes to `main` and
`master`, or manually with an optional MSIX version (default `1.0.4.0`). It uses
Flutter 3.41.2 on Windows Server 2022, installs locked dependencies, runs the
tests, and uploads the Windows release folder and MSIX as separate artifacts.
Download and extract the entire release artifact to run `commonquiz.exe`.

Configure these repository secrets before running the workflow:

- `API_KEY`
- `YOUR_KEY`
- `YOUR_DB_KEY`
- `YOUR_DB_PASS_KEY`

The workflow creates the required `.env` asset from these secrets. The asset is
bundled in both outputs, including the hidden file in the release artifact.

MSIX packages use the registered Microsoft Store identity:

- Identity name: `ParisoftAI.ElectricianExamPrepNEC`
- Publisher: `CN=BAFD5734-F723-4C9B-9352-3ED618975B07`
- Publisher display name: `ParisoftAI`
- Package family name: `ParisoftAI.ElectricianExamPrepNEC_pxzj9qxns246m`

The family name is derived from the identity name and publisher. The workflow
uses the checked-in values; old `NEC_MSIX_*` repository variables are no longer
used. After packaging, the build checks the actual MSIX manifest and required
files before uploading artifacts. A failed check stops the build.

Store distribution supplies signing; direct MSIX distribution requires a trusted
signature. See the [MSIX packaging configuration](https://pub.dev/packages/msix/example).

For a local build, use Windows with Visual Studio's Desktop development with C++
workload, Flutter 3.41.2, PowerShell 7, Python 3, and the required `.env` file:

```powershell
flutter config --enable-windows-desktop
flutter pub get --enforce-lockfile
flutter test
./scripts/build_windows.ps1 -Msix -MsixVersion 1.0.4.0
```

Omit `-Msix` to build just the release folder. Store identity parameters default
to the registered values and reject other identities. Outputs are under
`build/windows/x64/runner/Release/`.

### Replacing a rejected Store package

The next Windows package version is `1.0.4.0`. Partner Center has already seen
`1.0.3.0`; uploading different contents with that same package identity and
version causes a duplicate full-name error. Renaming the `.msix` file does not
change its identity. For later changed uploads, increment the package version
again and keep the Store revision (fourth component) at `0`.

Rebuild using the updated Windows workflow or local Windows command above.
An existing MSIX still contains the old manifest; retrying that file will fail.
Download the MSIX artifact from the new successful run and extract it.

Remove the conflicting uploaded package from the current submission in Partner
Center and click **Save** to confirm its removal. Upload the newly built
`electrician-exam-prep-nec.msix`, and resolve any remaining validation errors.
Select the Windows Desktop device family for this Windows desktop app. If using
market groups, upload at least one valid package to each group before submitting.
