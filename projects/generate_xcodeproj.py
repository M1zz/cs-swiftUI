#!/usr/bin/env python3
"""
Xcode 프로젝트 파일(.xcodeproj) 자동 생성 스크립트

Xcode 프로젝트 네비게이터 구조:
  📁 final/           ← 완성 소스 (컴파일 대상)
  📁 start/           ← 스켈레톤 소스 (레퍼런스만, 컴파일 안 됨)
  📄 StudyGuide.html  ← PDF 학습 가이드 (리소스로 포함)
  📁 Products/
"""

import os
import hashlib

BASE = os.path.dirname(os.path.abspath(__file__))

PROJECTS = [
    {
        "dir": "01-calculator",
        "name": "Calculator",
        "bundle": "com.devari.calculator",
        "files": [
            "CalcButton.swift",
            "CalculatorLogic.swift",
            "ContentView.swift",
            "CalculatorApp.swift",
        ],
    },
    {
        "dir": "02-timer",
        "name": "TimerApp",
        "bundle": "com.devari.timerapp",
        "files": [
            "RingProgressView.swift",
            "TimerView.swift",
            "StopwatchView.swift",
            "ContentView.swift",
            "TimerApp.swift",
        ],
    },
    {
        "dir": "03-cart",
        "name": "ShoppingCart",
        "bundle": "com.devari.shoppingcart",
        "files": [
            "Models.swift",
            "CartStore.swift",
            "ProductListView.swift",
            "CartView.swift",
            "ContentView.swift",
            "CartApp.swift",
        ],
    },
    {
        "dir": "04-memo",
        "name": "MemoApp",
        "bundle": "com.devari.memoapp",
        "files": [
            "Memo.swift",
            "MemoStore.swift",
            "MemoListView.swift",
            "MemoEditView.swift",
            "MemoApp.swift",
        ],
    },
    {
        "dir": "05-weather",
        "name": "WeatherApp",
        "bundle": "com.devari.weatherapp",
        "files": [
            "WeatherModel.swift",
            "WeatherService.swift",
            "WeatherView.swift",
            "ContentView.swift",
            "WeatherApp.swift",
        ],
    },
    {
        "dir": "06-budget",
        "name": "BudgetApp",
        "bundle": "com.devari.budgetapp",
        "files": [
            "Transaction.swift",
            "AddTransactionView.swift",
            "DashboardView.swift",
            "TransactionListView.swift",
            "ContentView.swift",
            "BudgetApp.swift",
        ],
    },
]


def uid(seed):
    return hashlib.md5(seed.encode()).hexdigest()[:24].upper()


def make_pbxproj(proj):
    name    = proj["name"]
    bundle  = proj["bundle"]
    files   = proj["files"]

    def u(s): return uid(f"{name}:{s}")

    # ── 구조 UUID ──────────────────────────────────────────────────────
    main_grp    = u("MainGroup")
    final_grp   = u("FinalGroup")
    start_grp   = u("StartGroup")
    prod_grp    = u("ProductsGroup")
    target      = u("Target")
    project     = u("Project")
    fw_phase    = u("FrameworksPhase")
    src_phase   = u("SourcesPhase")
    res_phase   = u("ResourcesPhase")

    # final 파일 UUID
    final_refs  = {f: u(f"FinalRef:{f}") for f in files}
    final_blds  = {f: u(f"FinalBld:{f}") for f in files}

    # start 파일 UUID (컴파일 안 됨, 레퍼런스만)
    start_refs  = {f: u(f"StartRef:{f}") for f in files}

    # Assets / App / StudyGuide
    assets_ref  = u("AssetsRef")
    assets_bld  = u("AssetsBld")
    app_ref     = u("AppRef")
    guide_ref   = u("GuideRef")
    guide_bld   = u("GuideBld")

    # 설정 UUID
    dbg_prj = u("DebugProject");  rel_prj = u("ReleaseProject")
    dbg_tgt = u("DebugTarget");   rel_tgt = u("ReleaseTarget")
    prj_cfg = u("ProjectCfgList"); tgt_cfg = u("TargetCfgList")

    # ── PBXBuildFile (final 소스 + assets + studyguide) ────────────────
    bld_sec = ""
    for f in files:
        bld_sec += f"\t\t{final_blds[f]} /* {f} in Sources */ = {{isa = PBXBuildFile; fileRef = {final_refs[f]} /* {f} */; }};\n"
    bld_sec += f"\t\t{assets_bld} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {assets_ref} /* Assets.xcassets */; }};\n"
    bld_sec += f"\t\t{guide_bld} /* StudyGuide.html in Resources */ = {{isa = PBXBuildFile; fileRef = {guide_ref} /* StudyGuide.html */; }};\n"

    # ── PBXFileReference ───────────────────────────────────────────────
    ref_sec = f"\t\t{app_ref} /* {name}.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = {name}.app; sourceTree = BUILT_PRODUCTS_DIR; }};\n"
    for f in files:
        ref_sec += f"\t\t{final_refs[f]} /* {f} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {f}; sourceTree = \"<group>\"; }};\n"
        ref_sec += f"\t\t{start_refs[f]} /* {f} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {f}; sourceTree = \"<group>\"; }};\n"
    ref_sec += f"\t\t{assets_ref} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = \"<group>\"; }};\n"
    ref_sec += f"\t\t{guide_ref} /* StudyGuide.html */ = {{isa = PBXFileReference; lastKnownFileType = text.html; path = StudyGuide.html; sourceTree = \"<group>\"; }};\n"

    # ── Group children ─────────────────────────────────────────────────
    final_children = "\n".join(f"\t\t\t\t{final_refs[f]} /* {f} */," for f in files)
    final_children += f"\n\t\t\t\t{assets_ref} /* Assets.xcassets */,"
    start_children = "\n".join(f"\t\t\t\t{start_refs[f]} /* {f} */," for f in files)

    # ── Sources build phase (final only) ──────────────────────────────
    src_bld = "\n".join(f"\t\t\t\t{final_blds[f]} /* {f} in Sources */," for f in files)

    return f"""// !$*UTF8*$!
{{
\tarchiveVersion = 1;
\tclasses = {{
\t}};
\tobjectVersion = 56;
\tobjects = {{

/* Begin PBXBuildFile section */
{bld_sec}/* End PBXBuildFile section */

/* Begin PBXFileReference section */
{ref_sec}/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t{fw_phase} /* Frameworks */ = {{
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t{main_grp} = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{final_grp} /* final */,
\t\t\t\t{start_grp} /* start */,
\t\t\t\t{guide_ref} /* StudyGuide.html */,
\t\t\t\t{prod_grp} /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{final_grp} /* final */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{final_children}
\t\t\t);
\t\t\tpath = final;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{start_grp} /* start */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{start_children}
\t\t\t);
\t\t\tpath = start;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{prod_grp} /* Products */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{app_ref} /* {name}.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t{target} /* {name} */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {tgt_cfg} /* Build configuration list for PBXNativeTarget "{name}" */;
\t\t\tbuildPhases = (
\t\t\t\t{src_phase} /* Sources */,
\t\t\t\t{fw_phase} /* Frameworks */,
\t\t\t\t{res_phase} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = {name};
\t\t\tproductName = {name};
\t\t\tproductReference = {app_ref} /* {name}.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t{project} /* Project object */ = {{
\t\t\tisa = PBXProject;
\t\t\tattributes = {{
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1500;
\t\t\t\tLastUpgradeCheck = 1500;
\t\t\t\tTargetAttributes = {{
\t\t\t\t\t{target} = {{
\t\t\t\t\t\tCreatedOnToolsVersion = 15.0;
\t\t\t\t\t}};
\t\t\t\t}};
\t\t\t}};
\t\t\tbuildConfigurationList = {prj_cfg} /* Build configuration list for PBXProject "{name}" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = ko;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t\tko,
\t\t\t);
\t\t\tmainGroup = {main_grp};
\t\t\tproductRefGroup = {prod_grp} /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t{target} /* {name} */,
\t\t\t);
\t\t}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t{res_phase} /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t\t{assets_bld} /* Assets.xcassets in Resources */,
\t\t\t\t{guide_bld} /* StudyGuide.html in Resources */,
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t{src_phase} /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{src_bld}
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t{dbg_prj} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$(inherited)",
\t\t\t\t);
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{rel_prj} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t}};
\t\t\tname = Release;
\t\t}};
\t\t{dbg_tgt} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASSET_CATALOG_COMPILER_OPTIMIZATION = space;
\t\t\t\tBUNDLE_IDENTIFIER = {bundle};
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait";
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLE_SWIFT_VERSION = 5.0;
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = {bundle};
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{rel_tgt} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASSET_CATALOG_COMPILER_OPTIMIZATION = space;
\t\t\t\tBUNDLE_IDENTIFIER = {bundle};
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait";
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLE_SWIFT_VERSION = 5.0;
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = {bundle};
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Release;
\t\t}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t{prj_cfg} /* Build configuration list for PBXProject "{name}" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{dbg_prj} /* Debug */,
\t\t\t\t{rel_prj} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
\t\t{tgt_cfg} /* Build configuration list for PBXNativeTarget "{name}" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{dbg_tgt} /* Debug */,
\t\t\t\t{rel_tgt} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
/* End XCConfigurationList section */
\t}};
\trootObject = {project} /* Project object */;
}}
"""


def make_xcscheme(proj):
    name   = proj["name"]
    target = uid(f"{name}:Target")
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{target}"
               BuildableName = "{name}.app"
               BlueprintName = "{name}"
               ReferencedContainer = "container:{name}.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{target}"
            BuildableName = "{name}.app"
            BlueprintName = "{name}"
            ReferencedContainer = "container:{name}.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{target}"
            BuildableName = "{name}.app"
            BlueprintName = "{name}"
            ReferencedContainer = "container:{name}.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction buildConfiguration = "Debug"/>
   <ArchiveAction buildConfiguration = "Release" revealArchiveInOrganizer = "YES"/>
</Scheme>
"""


ASSETS_CONTENTS = '{\n  "info" : {\n    "author" : "xcode",\n    "version" : 1\n  }\n}\n'
APPICON_CONTENTS = '{\n  "images" : [{"idiom":"universal","platform":"ios","size":"1024x1024"}],\n  "info" : {"author":"xcode","version":1}\n}\n'
ACCENT_CONTENTS  = '{\n  "colors" : [{"idiom":"universal"}],\n  "info" : {"author":"xcode","version":1}\n}\n'


def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  ✓ {os.path.relpath(path, BASE)}")


def generate(proj):
    d    = os.path.join(BASE, proj["dir"])
    name = proj["name"]

    print(f"\n🔨 {proj['dir']} — {name}")

    xp = os.path.join(d, f"{name}.xcodeproj")
    write(os.path.join(xp, "project.pbxproj"), make_pbxproj(proj))
    write(os.path.join(xp, "xcshareddata", "xcschemes", f"{name}.xcscheme"), make_xcscheme(proj))

    # Assets.xcassets (final/ 안에 위치)
    assets = os.path.join(d, "final", "Assets.xcassets")
    write(os.path.join(assets, "Contents.json"), ASSETS_CONTENTS)
    write(os.path.join(assets, "AppIcon.appiconset", "Contents.json"), APPICON_CONTENTS)
    write(os.path.join(assets, "AccentColor.colorset", "Contents.json"), ACCENT_CONTENTS)


if __name__ == "__main__":
    print("🚀 Xcode 프로젝트 재생성 (final + start + StudyGuide 구조)")
    print("=" * 60)
    for proj in PROJECTS:
        generate(proj)
    print("\n" + "=" * 60)
    print("✅ 완료!")
    print("   Xcode 네비게이터에서 final / start / StudyGuide.html 확인 가능")
