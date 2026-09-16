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
`master`, or manually with an optional MSIX version (default `1.0.3.0`). It uses
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

MSIX packages are unsigned. The package identity is `ParisoftAI.NECElectricalExamPrep`.
The default publisher in `pubspec.yaml` is a development placeholder. Before submitting to Microsoft Store, set these
repository variables to the exact values from Partner Center's Product identity:

- `NEC_MSIX_IDENTITY_NAME`: optional override for Package/Identity/Name (defaults to `ParisoftAI.NECElectricalExamPrep`)
- `NEC_MSIX_PUBLISHER`: Package/Identity/Publisher
- `NEC_MSIX_PUBLISHER_NAME`: optional override for Package/Properties/PublisherDisplayName (defaults to `ParisoftAI`; remove any stale override or set it to `ParisoftAI`)

Store distribution supplies signing; direct MSIX distribution requires a trusted
signature. See the [MSIX packaging configuration](https://pub.dev/packages/msix/example).

For a local build, use Windows with Visual Studio's Desktop development with C++
workload, Flutter 3.41.2, PowerShell 7, and the required `.env` file:

```powershell
flutter config --enable-windows-desktop
flutter pub get --enforce-lockfile
flutter test
./scripts/build_windows.ps1 -Msix -MsixVersion 1.0.3.0
```

Omit `-Msix` to build just the release folder. For a Store package, also pass
`-IdentityName`, `-Publisher`, and `-PublisherDisplayName` with your registered
values. Outputs are under `build/windows/x64/runner/Release/`.

### Replacing a rejected Store package

The publisher display name must be `ParisoftAI`, matching the Partner Center
account. The app display name remains `Electrician Exam Prep: NEC`.
After updating the configuration, rebuild the MSIX with the Windows workflow
or the local Windows command above; an existing MSIX will still contain the old
manifest. Ensure `NEC_MSIX_PUBLISHER_NAME` does not override the corrected value.
The separate `NEC_MSIX_PUBLISHER` value must match Product identity exactly;
do not use the development placeholder `CN=ElectricianExamPrep` for submission.

Delete the rejected package in Partner Center, upload the newly built
`electrician-exam-prep-nec.msix`, and resolve any remaining validation errors.
Select the Windows Desktop device family for this Windows desktop app. If using
market groups, upload at least one valid package to each group before submitting.
