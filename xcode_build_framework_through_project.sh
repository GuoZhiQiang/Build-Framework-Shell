set -e
 
# 2
# Set the name and file path. 设置名字以及路径变量
FRAMEWORK_NAME="名字Framework"
WORK_DIR='build'
OUTPUT_ROOT='Products'
DEVICE_DIR=${WORK_DIR}/'Release-iphoneos'/${FRAMEWORK_NAME}'.framework'
SIMULATOR_DIR=${WORK_DIR}/'Release-iphonesimulator'/${FRAMEWORK_NAME}'.framework'
OUTPUT_DIR=${OUTPUT_ROOT}/${FRAMEWORK_NAME}'.framework'

# 3
if [ -d ${WORK_DIR} ]; then
 rm -rf ${WORK_DIR}
fi
 
# 4
# Build the framework for device and simulator with all architectures. 编译真机和模拟器支持的所有架构，如果需要module，加上defines_module=yes
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release -arch arm64 -arch armv7s -arch armv7 only_active_arch=no -sdk "iphoneos"
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release -arch x86_64 -arch i386 only_active_arch=no -sdk "iphonesimulator"
 
# 5
if [ -d ${OUTPUT_DIR} ]; then
 rm -rf ${OUTPUT_DIR}
fi

# 6 
# Create the output file including the folders. 创建目标文件，以及其中包含的文件夹
mkdir -p ${OUTPUT_DIR}
 
# 7
# Copy the device version of framework to destination. 先拷贝真机framework到目标文件
cp -r ${DEVICE_DIR}/ ${OUTPUT_DIR}/
 
# 8
# Replace the framework executable within the output file framework with
# a new version created by merging the device and simulator
# frameworks' executables with lipo. 合并真机和模拟器 .framework 里面的可执行文件FRAMEWORK_NAME 到目标文件.framework 下
lipo -create -output ${OUTPUT_DIR}/${FRAMEWORK_NAME} ${DEVICE_DIR}/${FRAMEWORK_NAME} ${SIMULATOR_DIR}/${FRAMEWORK_NAME}
 
# 9
# 第4步如果需要 swift module,那么需要解注释下面这个命令，拷贝真机和模拟器下的 .swiftmudule 文件到目标文件
# cp -r "${SRCROOT}/build/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/" "${HOME}/Desktop/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"
