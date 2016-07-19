#!/bin/sh

#统一fail处理函数
Failed()
{
    echo "Failed: $*"
    exit -1
}

build_type=$1 #Debug Adhoc Appstore

if [ -z $build_type ]; then
  build_type="Appstore"
fi

configuration="Debug"

if [[ "$build_type" = "Debug" ]]; then
	CODE_SIGN_IDENTITY="iPhone Developer: liguang sun (HHVG46TPJ8)"
	PROVISIONING_PROFILE="8a2bf49c-01e4-469c-aec7-62e6f510140e"
	configuration="Debug"
fi

if [[ "$build_type" = "Adhoc" ]]; then
	CODE_SIGN_IDENTITY="iPhone Developer: liguang sun (HHVG46TPJ8)"
	PROVISIONING_PROFILE="8a2bf49c-01e4-469c-aec7-62e6f510140e"
	configuration='Release'
fi

if [[ "$build_type" = "Appstore" ]]; then
	CODE_SIGN_IDENTITY="iPhone Developer: liguang sun (HHVG46TPJ8)"
	PROVISIONING_PROFILE="8a2bf49c-01e4-469c-aec7-62e6f510140e"
	configuration='Release'
fi

root_path="`dirname $0`/.."
root_path_prefix=${root_path:0:1}
if [[ "$root_path_prefix" != "/" ]]; then
	root_path="`pwd`/${root_path}"
fi
# root_path="`pwd`/.."
xcodePath=/usr/bin

src_path="${root_path}/yuantu"
output_dir="${root_path}/output/tmp"
info_plist_path="${src_path}/yuantu/Info.plist"
build_app_file_path="${output_dir}/yuantu.app"
build_sym_file_path="${output_dir}/yuantu.app.dSYM"

runTarget="yuantu"
sdk="iphoneos"

#删除之前的产出

if [[ ! -z "$output_dir" ]]  && [[ ! -z "$root_path" ]]; then
	rm -rf ${output_dir}
fi

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${info_plist_path}")
buildNumber=$((buildNumber+1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildNumber}" "${info_plist_path}"
version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${info_plist_path}")

app_file_path="${output_dir}/yuantu-${configuration}-${version}.${buildNumber}.app"
ipa_file_path="${output_dir}/yuantu-${configuration}-${build_type}-${version}.${buildNumber}.ipa"
sym_file_path="${output_dir}/yuantu-${configuration}-${version}.${buildNumber}.app.dSYM"
build_dir="${output_dir}/yuantu-${configuration}-${version}.${buildNumber}"
final_output_dir="${root_path}/output/yuantu-${configuration}-${build_type}-${version}.${buildNumber}"

#进入工程目录
cd "${src_path}"

#开始编译操作

echo "Build and Archive Run Target..."

"${xcodePath}/xcodebuild" -target "$runTarget" -configuration "$configuration" -sdk "$sdk" clean || Failed "Clean Run Target"
"${xcodePath}/xcodebuild" -configuration "$configuration" -sdk "$sdk" CONFIGURATION_BUILD_DIR="${output_dir}" CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${PROVISIONING_PROFILE}" || Failed "Build Run Target"

mv "${build_app_file_path}" "${app_file_path}"
mv "${build_sym_file_path}" "${sym_file_path}"

echo "Build and Archive Run Target end"

if [ ! -d "${output_dir}" ];then
    Failed "No build directory"
fi

#开始打包操作

"${xcodePath}/xcrun" -sdk "$sdk" PackageApplication "${app_file_path}" -o "${ipa_file_path}" || Failed "Package ipa"

mv "${output_dir}" "${final_output_dir}"

exit 0
