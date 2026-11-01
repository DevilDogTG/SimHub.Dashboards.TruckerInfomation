# SimHub Dashboard: Trucker Information

A 960x540 SimHub dashboard for Euro Truck Simulator 2 and American Truck Simulator: speed, speed limit, cruise
control, RPM, fuel, temperatures, air pressure, warning lights, job and rest-stop info. It has a driving screen and
an idle screen.

## Requirements

- SimHub 9.x with ETS2/ATS telemetry
- The [DevDogs Truck Simulator](https://github.com/DevilDogTG/SimHub.Plugins.TruckSimulator) SimHub plugin (`DDTruckPlugin.*` properties)

## Layout

| Path | What it is |
|---|---|
| `src/Trucker Information/` | The dashboard folder exactly as SimHub stores it in `DashTemplates` |
| `scripts/Install-SimHubLink.ps1` | Links SimHub's `DashTemplates\Trucker Information` to `src/Trucker Information/` |

`.simhubdash` exports are not tracked; they are attached to GitHub releases.

## Editing with SimHub

SimHub's Dash Studio saves into `DashTemplates`. A directory junction there makes it save straight into this repo.

1. Close SimHub.
2. From an elevated PowerShell in the repo root:

   ```powershell
   .\scripts\Install-SimHubLink.ps1
   ```

   SimHub's existing copy is moved to `$HOME\SimHub-DashBackups\`, not deleted.
3. Start SimHub and edit as usual, then commit from the repo.

The junction means SimHub always shows the branch that is checked out. Close the dashboard in Dash Studio before switching branches.

Don't import a `.simhubdash` of the same name while linked: SimHub would overwrite the folder, and that folder is now this repo.

## Readable diffs

`Trucker Information.djson` is a single minified JSON line. Register the pretty-print diff driver once per clone:

```powershell
git config diff.djson.textconv "PYTHONUTF8=1 python -m json.tool --no-ensure-ascii"
```

## Releasing

Every PR that bumps `DashboardVersion` is released once it merges. PRs without a bump are not released.

`DashboardVersion` (set in Dash Studio's dashboard properties) is `X.Y.Z`, bumped in the PR that makes the change:

| Bump | When |
|---|---|
| X | A deliberate major release, decided by the maintainer |
| Y (Z resets to 0) | A new feature, or a dependency update: SimHub, the DevDogs plugin, or another plugin |
| Z | A fix to something that already exists |
| None | Hidden layers, refactors with no visible change, repo tooling |

A `.simhubdash` is a zip of the `Trucker Information/` folder, so build it from the merged commit rather than exporting it
from Dash Studio. It then holds exactly the files tracked under `src/` (SimHub's `_Backups/` is git-ignored):

```powershell
git archive --format=zip -9 -o "Trucker.Information.v<version>.simhubdash" <commit>:src
```

Tag that commit and publish the release with the file attached:

```powershell
git tag -a v<version> <commit> -m "release: v<version>"
git push origin v<version>
gh release create v<version> --title "v<version>" --notes-file <notes.md> --verify-tag "Trucker.Information.v<version>.simhubdash"
```

The release notes state the SimHub version the dashboard was saved with and the minimum DevDogs Truck Simulator plugin version.
