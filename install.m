(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: install															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2014-2016 Vladyslav Shtabovenko
*)

(* :Summary:  Installs FeynHelpers *)

(* ------------------------------------------------------------------------ *)

InstallFeynHelpers::nofc =
"Looks like you don't have FeynCalc installed. FeynHelpers cannot work without FeynCalc, so please \
install it first.";

InstallFeynHelpers::notcomp =
"Your Mathematica version is too old. FeynHelpers requires at least Mathematica 8. Installation aborted!";

InstallFeynHelpers::failed =
"Download of `1` failed. Installation aborted!";

AutoOverwriteFeynHelpersDirectory::usage="AutoOverwriteFeynHelpersDirectory is an option of InstallFeynHelpers. If \
set to True, the existing FeynHelpers directory will be deleted without any further notice. The default
value None means that the user will be asked by a dialog. False means that the directory will be overwritten.";


AutoOverwritePackageXDirectory::usage="AutoOverwritePackageXDirectory is an option of InstallPackageX. If \
set to True, the existing Package-X directory will be deleted without any further notice. The default
value None means that the user will be asked by a dialog. False means that the directory will be overwritten.";

AutoDisableInsufficientVersionWarning::usage="AutoDisableInsufficientVersionWarning is an option of InstallFeynHelpers. If \
set to True, warning messages for notebooks that were created with a newer Mathematica version will be silently disabled. \
This is needed to use FeynHelpers documentation in Mathematica 8 and 9, since otherwise the warning message will appear every \
time one opens a help page for a FeynHelpers function. The default value None means that the user will be asked by a dialog. \
False means that the warning will not be disabled.";

FeynArtsMirrorLink::usage="FeynArtsMirrorLink is an option of InstallFeynHelpers. It specifies the url \
to the mirror repository of FeynArts. This repository is maintained by FeynHelpers developers and tries to follow \
the development of FeynArts using git. It is also used to install FeynArts with InstallFeynHelpers.";

AutoInstallFeynArts::usage="AutoInstallFeynArts is an option of InstallFeynHelpers. If \
set to True, FeynArts will be installed automatically.";

FeynHelpersDevelopmentVersionLink::usage="FeynHelpersDevelopmentVersionLink is an option of InstallFeynHelpers. It specifies the url \
to the main repository of FeynHelpers. This repository is used to install the development version of FeynHelpers.";

FeynHelpersStableVersionLink::usage="FeynHelpersStableVersionLink is an option of InstallFeynHelpers. It specifies the url \
to the latest stable release of FeynHelpers.";

InstallFeynHelpersDevelopmentVersion::usage="InstallFeynHelpersDevelopmentVersion is an option of InstallFeynHelpers. If \
set to True, the installer will download the latest development version of FeynHelpers from the git repository. \
Otherwise it will install the latest stable version.";

InstallFeynHelpersTo::usage="InstallFeynHelpersTo is an option of InstallFeynHelpers. It specifies, the full path \
to the directory where FeynHelpers will be installed.";

If[  $VersionNumber == 8,
(*To use FetchURL in MMA8 we need to load URLTools first *)
Needs["Utilities`URLTools`"];
];

If [Needs["FeynCalc`"]===$Failed,
	Message[InstallFeynHelpers::nofc];
	Abort[]
];

Options[InstallFeynHelpers]={
	AutoInstallPackageX->None,
	AutoOverwriteFeynHelpersDirectory->None,
	FeynHelpersDevelopmentVersionLink->"https://github.com/FeynCalc/feynhelpers/archive/master.zip",
	(* There is no stable version at the moment*)
	FeynHelpersStableVersionLink->"https://github.com/FeynCalc/feynhelpers/archive/master.zip",
	InstallFeynHelpersDevelopmentVersion->False,
	InstallFeynHelpersTo->FileNameJoin[{$FeynCalcDirectory, "AddOns","FeynHelpers"}]
};

Options[InstallPackageX]={
	AutoOverwritePackageXDirectory -> None,
	PackageXLink->"http://www.hepforge.org/archive/packagex/X-2.0.0.zip",
	InstallPackageXTo->FileNameJoin[{$UserBaseDirectory, "Applications","X"}]
};

InstallPackageX[OptionsPattern[]]:=
	Module[{tmpzip,zip,FCGetUrl,unzipDir,packageDir,packageName,strOverwriteFCdit},
		(* Install PackageX	*)

		packageDir=OptionValue[InstallPackageXTo];
		zip = OptionValue[PackageXLink];
		packageName = "Package-X";

strOverwriteFCdit="Looks like " <> packageName <> " is already installed. Do you want to replace the content \
of " <> packageDir <> " with the downloaded version of " <> packageName <> "? If you are using any custom configuration \
files or add-ons that are located in that directory, please backup them in advance.";

		If[$VersionNumber == 8,
			(*To use FetchURL in MMA8 we need to load URLTools first *)
			FCGetUrl[x_]:= Utilities`URLTools`FetchURL[x],
			FCGetUrl[x_]:= URLSave[x,CreateTemporary[]]
		];

		(* If the package directory already exists, ask the user about overwriting *)
		If[ DirectoryQ[packageDir],

		If[ OptionValue[AutoOverwritePackageXDirectory],

			Quiet@DeleteDirectory[packageDir, DeleteContents -> True],

			Null,
			If[ ChoiceDialog[strOverwriteFCdit,{"Yes, overwrite the " <> packageName <>" directory"->True,
				"No! I need to do a backup first."->False}],
				Quiet@DeleteDirectory[packageDir, DeleteContents -> True],
				Abort[]
			]
		]
	];


		WriteString["stdout", "Downloading Package-X from ", zip," ..."];
		tmpzip=FCGetUrl[zip];
		unzipDir= tmpzip<>".dir";
		WriteString["stdout", "done! \n"];

		(* Extract to the content	*)
		WriteString["stdout", "Package-X zip file was saved to ", tmpzip,".\n"];
		WriteString["stdout", "Extracting Package-X zip file to ", packageDir, " ..."];
		ExtractArchive[tmpzip, unzipDir];
		WriteString["stdout", "done! \n"];

		(* Move the files to the final destination	*)
		WriteString["stdout", "Copying Package-X to ", packageDir, " ..."];
		CopyDirectory[FileNameJoin[{unzipDir,"X"}],packageDir];
		WriteString["stdout", "done! \n"];

		(* Delete the downloaded file	*)
		Quiet@DeleteFile[tmpzip];

		(* Delete the extracted archive *)
		Quiet@DeleteDirectory[unzipDir, DeleteContents -> True];

	];

InstallFeynHelpers[OptionsPattern[]]:=
	Module[{	unzipDir, tmpzip, gitzip, packageName, packageDir,
				strPackageX,FCGetUrl,
				strOverwriteFCdit, xInstalled, zipDir},

	If[OptionValue[InstallFeynHelpersDevelopmentVersion],
		gitzip = OptionValue[FeynHelpersDevelopmentVersionLink];
		zipDir = "feynhelpers-master",
		gitzip = OptionValue[FeynHelpersStableVersionLink];
		zipDir = "feynhelpers-stable"
	];
	xInstalled=False;

	packageName = "FeynHelpers";
	packageDir = OptionValue[InstallFeynHelpersTo];

strPackageX="Do you want to install Package-X from "<> OptionValue[InstallPackageX,PackageXLink] <> "? Package-X is a \
Mathematica package for 1-loop calculations written by Hiren Patel (packagex.hepforge.org, arXiv:1503.01469). It contains \
a library of analytic expression for Passarino-Veltman functions that can be accessed via FeynHelpers. This allows you to \
evaluate such integrals directly in your FeynCalc session. Without Package-X you cannot use FeynHelpers' PaXEvaluate function. \
Before you proceed, please look at the license of Package-X and make sure that you understand it and that you agree with it.";

strOverwriteFCdit="Looks like FeynHelpers is already installed. Do you want to replace the content \
of " <> packageDir <> " with the downloaded version of FeynHelpers? If you are using any custom configuration \
files or add-ons that are located in that directory, please backup them in advance.";

	If[$VersionNumber < 8,
		Message[InstallFeynHelpers::notcomp];
		Abort[]
	];

	If[$VersionNumber == 8,
		(*To use FetchURL in MMA8 we need to load URLTools first *)
		FCGetUrl[x_]:= Utilities`URLTools`FetchURL[x],
		FCGetUrl[x_]:= URLSave[x,CreateTemporary[]]
	];


	(* If the package directory already exists, ask the user about overwriting *)
	If[ DirectoryQ[packageDir],

		If[ OptionValue[AutoOverwriteFeynHelpersDirectory],

			Quiet@DeleteDirectory[packageDir, DeleteContents -> True],

			Null,
			If[ ChoiceDialog[strOverwriteFCdit,{"Yes, overwrite the " <> packageName <>" directory"->True,
				"No! I need to do a backup first."->False}],
				Quiet@DeleteDirectory[packageDir, DeleteContents -> True],
				Abort[]
			]
		]
	];

	(* Download FeynHelpers tarball	*)
	WriteString["stdout", "Downloading FeynHelpers from ", gitzip," ..."];
	tmpzip=FCGetUrl[gitzip];
	unzipDir= tmpzip<>".dir";
	WriteString["stdout", "done! \n"];

	(* Extract to the content	*)
	WriteString["stdout", "FeynHelpers zip file was saved to ", tmpzip,".\n"];
	WriteString["stdout", "Extracting FeynHelpers zip file to ", unzipDir, " ..."];
	ExtractArchive[tmpzip, unzipDir];
	WriteString["stdout", "done! \n"];

	(* Delete the downloaded file	*)
	Quiet@DeleteFile[tmpzip];

	(* Move the files to the final destination	*)
	WriteString["stdout", "Copying "<>packageName<>" to ", packageDir, " ..."];
	Print[FileNameJoin[{unzipDir,zipDir}]];
	CopyDirectory[FileNameJoin[{unzipDir,zipDir}],packageDir];
	WriteString["stdout", "done! \n"];
	(* Delete the extracted archive *)
	Quiet@DeleteDirectory[unzipDir, DeleteContents -> True];

	WriteString["stdout", "done! \n"];

	If[ OptionValue[AutoInstallPackageX],

		xInstalled=True;
		InstallPackageX[],
		Null,
		If[ ChoiceDialog[strPackageX],
			xInstalled=True;
			InstallPackageX[]
		]
	];


	WriteString["stdout","\nInstallation complete! To load FeynHelpers, restart Mathematica \
and evaluate \n\n $LoadAddOns={\"FeynHelpers\"}; \n\n before you load FeynCalc; \n"];



];
