#!/bin/bash

set -e

# Configuration
QT_VERSION="6.10.0"
BUILD_DIR="build-release"
INSTALL_DIR="qt-release-${QT_VERSION}-20251024-linux-x86_64-clang"
SOURCE_DIR="qt-everywhere-src-${QT_VERSION}"
ARCHIVE_NAME="${INSTALL_DIR}.tar.xz"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR not found"
    echo "Please ensure the Qt source is extracted in the src directory"
    exit 1
fi

# Create build directory
echo "Creating build directory..."
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Configure Qt with static libraries and dynamic runtime
echo "Configuring Qt..."
# 启动gnu扩展。使用 gnu++17 而不是 c++17
cmake -G "Ninja" \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_EXTENSIONS=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DQT_BUILD_EXAMPLES=OFF \
    -DQT_BUILD_TESTS=OFF \
    -DQT_BUILD_BENCHMARKS=OFF \
    -DCMAKE_INSTALL_PREFIX=../$INSTALL_DIR \
    ../$SOURCE_DIR

# Build Qt
echo "Building Qt..."
ninja -j$(nproc)

# Install Qt
echo "Installing Qt..."
ninja install

# Return to parent directory
cd ..

# Create archive
echo "Creating archive $ARCHIVE_NAME..."
tar -cJf $ARCHIVE_NAME $INSTALL_DIR

# Verify archive was created
if [ -f "$ARCHIVE_NAME" ]; then
    echo "Archive created successfully: $ARCHIVE_NAME"
    
    # Clean up build and install directories
    echo "Cleaning up build directories..."
    rm -rf $BUILD_DIR
    rm -rf $INSTALL_DIR
    
    echo "Qt static release build completed successfully"
else
    echo "Error: Archive creation failed"
    exit 1
fi
