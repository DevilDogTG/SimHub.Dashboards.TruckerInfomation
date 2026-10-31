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

Export the dashboard from SimHub's Dash Studio and attach the `.simhubdash` to a GitHub release.
