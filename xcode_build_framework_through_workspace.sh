# 1
FMK_NAME="Target名称"
WORKSPACE_NAME=${FMK_NAME}
SCHEME_NAME=${FMK_NAME}
WRK_DIR='build'
# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
# 在根目录生成输出文件
OUTPUT_DIR=Products/${FMK_NAME}.framework

DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# 2
# workspace方式
xcodebuild -workspace ${WORKSPACE_NAME}".xcworkspace" -scheme ${SCHEME_NAME} -configuration "Release" -arch arm64 -arch armv7s -arch armv7 SYMROOT=$(PWD)/build -sdk iphoneos clean build
xcodebuild -workspace ${WORKSPACE_NAME}".xcworkspace" -scheme ${SCHEME_NAME} -configuration "Release" -arch x86_64 -arch i386 SYMROOT=$(PWD)/build -sdk iphonesimulator clean build

# 3
# Cleaning the oldest.
if [ -d ${OUTPUT_DIR} ]; then
 rm -rf ${OUTPUT_DIR}
fi

# 4
mkdir -p "${OUTPUT_DIR}"

# 5
# Copy the device version of framework to destination.
cp -R ${DEVICE_DIR}/ ${OUTPUT_DIR}/

# 6
lipo -create ${DEVICE_DIR}/${FMK_NAME} ${SIMULATOR_DIR}/${FMK_NAME} -output ${OUTPUT_DIR}/${FMK_NAME}

# 7
rm -rf ${WRK_DIR}
