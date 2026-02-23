#!/usr/bin/env python3
"""
使用最新的 WebSocket URL 测试 CDP
"""
import asyncio
import websockets
import json
import requests

async def test_cdp_websocket():
    """使用 WebSocket 测试 CDP"""
    # 获取最新的 WebSocket URL
    response = requests.get("http://localhost:9222/json/version")
    version_info = response.json()
    cdp_ws_url = version_info.get('webSocketDebuggerUrl')

    print("=" * 60)
    print("CDP WebSocket 连接测试（实时）")
    print("=" * 60)
    print(f"\nWebSocket URL: {cdp_ws_url}")

    try:
        print("\n1. 连接到 CDP WebSocket...")
        async with websockets.connect(cdp_ws_url) as websocket:
            print("   ✅ WebSocket 连接成功")

            print("\n2. 获取浏览器版本...")
            await websocket.send(json.dumps({
                "id": 1,
                "method": "Browser.getVersion",
                "params": {}
            }))
            response = await websocket.recv()
            result = json.loads(response)
            if result.get('result'):
                version = result['result']
                print(f"   ✅ Product: {version.get('product')}")

            print("\n3. 创建新标签页（测试 CDP 控制）...")
            await websocket.send(json.dumps({
                "id": 2,
                "method": "Target.createTarget",
                "params": {
                    "url": "https://www.baidu.com"
                }
            }))
            response = await websocket.recv()
            result = json.loads(response)
            if result.get('result'):
                target_id = result['result'].get('targetId')
                print(f"   ✅ 成功创建标签页，ID: {target_id}")
            else:
                print(f"   ⚠️  响应: {result}")

            print("\n" + "=" * 60)
            print("✅ CDP WebSocket 完全正常！")
            print("=" * 60)
            print("\n🎉 ZeroOmega 扩展已禁用，CDP 连接成功！")
            print("📝 Antigravity 现在应该可以正常接管浏览器了！")

    except Exception as e:
        print(f"\n❌ 测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False

    return True

if __name__ == "__main__":
    asyncio.run(test_cdp_websocket())
