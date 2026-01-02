LF Sandbox release note

The LF Sandbox is based on the LF COMP DEV cohort

Users:

5 Sandbox variants are provided in LD themes.
These variants can be altered without affecting any of the other cohorts.

To select a cohort:

1. Open LF sandbox apk (link provided elsewhere)
2. Login and select user icon right hand top
3. Select MANAGE WORKSPACE.
4. Select MANAGE bottom navigation bar.
5. Select GENERAL SETTINGS/SANDBOX
6. Enter password [1qaz]
7. Selectany of SANDBOX1 to 5
8. Restart app by removing it from active applications in Android
9. LD Themes are activated on application start up.

Developers:

To create a new sandbox apk:

1. Checkout development branch.
2. Rename to flutter_launcher_icons-lflfcompdev.yaml
3. Run dart pub run flutter_launcher_icons -f flutter_launcher_icons-lflfcompdev.yaml
   3.1 See bewlow for launch.json entry
4. Create apk for sandbox
5. Re-instate original flutter_launcher_icons-lf...yaml
6. Re-instate launcher icons used LF COMP DEV (remove sandbox launcher icons in android/app/src/lflfcompdev/res)
7. Copy apk to a new one drive folder under
   https://littlefishafrica.sharepoint.com/:f:/g/EgxHjAnSod9OgP26eqRhYTQBuLPdk3azBokrK706yAqc-g?e=Ek4FEF
8. Share link to new apk folder with team

{
"name": "sandbox lf lfcomp dev",
"request": "launch",
"type": "dart",
"args": [
"--flavor",
"lflfcompdev",
"--dart-define-from-file=env_files/sandbox.json",
]
},
