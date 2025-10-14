#!/bin/bash

echo "=== STRM Helper Quick Build Test ==="
echo "Testing simplified Dockerfile..."

# 测试简化版Dockerfile
echo "Building with Dockerfile.simple..."
if docker build -f Dockerfile.simple -t strm-helper-quick:test .; then
    echo "✅ Simplified build completed successfully!"
    
    # 检查构建结果
    echo "Checking build artifacts..."
    docker run --rm -it --entrypoint /bin/sh strm-helper-quick:test -c "ls -la /app/frontend/dist/"
    
    echo "✅ Quick test passed!"
    echo "You can now push your changes with confidence."
else
    echo "❌ Simplified build failed"
    echo "Trying debug build to get more information..."
    
    if docker build -f Dockerfile.debug -t strm-helper-debug:test .; then
        echo "✅ Debug build completed - check the logs above for details"
    else
        echo "❌ Debug build also failed"
        echo "Please check the error messages above and refer to docs/build-troubleshooting.md"
        exit 1
    fi
fi

echo "=== Test Complete ==="
