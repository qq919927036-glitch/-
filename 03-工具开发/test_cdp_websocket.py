#!/usr/bin/env python3
"""
使用 WebSocket 测试 CDP 连接
"""
import asyncio
import websockets
import json

async def test_cdp_websocket():
    """使用 WebSocket 测试 CDP"""
    cdp_ws_url = "ws://localhost:9222/devtools/browser/5bebd88a-9930-46d9-9d1d-b01211154437"

    print("=" * 60)
    print("CDP WebSocket 连接测试")
    print("=" * 60)

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
                print(f"   ✅ User Agent: {version.get('userAgent')}")

            print("\n3. 获取所有目标（标签页）...")
            await websocket.send(json.dumps({
                "id": 2,
                "method": "Target.getTargets",
                "params": {}
            }))
            response = await websocket.recv()
            result = json.loads(response)
            if result.get('result'):
                targets = result['result'].get('targetInfos', [])
                print(f"   ✅ 找到 {len(targets)} 个目标:")
                for target in targets:
                    print(f"      - {target.get('type')}: {target.get('title')}")
                    print(f"        URL: {target.get('url')}")

            print("\n4. 创建新目标（打开新标签页）...")
            await websocket.send(json.dumps({
                "id": 3,
                "method": "Target.createTarget",
                "params": {
                    "url": "https://xkcd.com/353/"
                }
            }))
            response = await websocket.recv()
            result = json.loads(response)
            if result.get('result'):
                target_id = result['result'].get('targetId')
                print(f"   ✅ 新目标 ID: {target_id}")

            print("\n" + "=" * 60)
            print("✅ CDP WebSocket 测试通过！")
            print("=" * 60)
            print("\n如果自动化工具仍然报错，可能的原因:")
            print("1. 工具可能使用了不兼容的 CDP 版本")
            print("2. 可能存在权限问题（沙箱/扩展限制）")
            print("3. 工具可能需要连接到页面而非浏览器级别")
            print("4. 可能需要配置特定的 Chrome 启动参数")
            print("\n建议的 Chrome 启动参数:")
            print("  --remote-debugging-port=9222")
            print("  --disable-features=VizDisplayCompositor")
            print("  --no-first-run")
            print("  --no-default-browser-check")

    except websockets.exceptions.ConnectionClosed:
        print("\n❌ WebSocket 连接已关闭")
        return False
    except Exception as e:
        print(f"\n❌ 测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False

    return True

if __name__ == "__main__":
    # 检查是否安装了所需的包
    try:
        import websockets
    except ImportError:
        print("❌ 缺少必需的包，请安装:")
        print("   pip3 install websockets")
        exit(1)

    asyncio.run(test_cdp_websocket())
