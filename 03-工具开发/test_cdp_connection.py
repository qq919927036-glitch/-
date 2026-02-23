#!/usr/bin/env python3
"""
测试 Chrome DevTools Protocol (CDP) 连接
"""
import requests
import json

def test_cdp_connection():
    """测试 CDP 连接"""
    cdp_url = "http://localhost:9222"

    print("=" * 60)
    print("Chrome DevTools Protocol 连接测试")
    print("=" * 60)

    try:
        # 测试 1: 检查版本
        print("\n1. 检查 CDP 版本...")
        response = requests.get(f"{cdp_url}/json/version")
        if response.status_code == 200:
            version_info = response.json()
            print(f"   ✅ Browser: {version_info.get('Browser')}")
            print(f"   ✅ Protocol: {version_info.get('Protocol-Version')}")
            print(f"   ✅ WebSocket URL: {version_info.get('webSocketDebuggerUrl')}")
        else:
            print(f"   ❌ 无法获取版本信息: {response.status_code}")
            return False

        # 测试 2: 列出所有页面
        print("\n2. 列出所有打开的页面...")
        response = requests.get(f"{cdp_url}/json")
        if response.status_code == 200:
            pages = response.json()
            print(f"   ✅ 找到 {len(pages)} 个目标:")
            for page in pages:
                if page.get('type') == 'page':
                    print(f"      - {page.get('title')} ({page.get('url')})")
                    print(f"        ID: {page.get('id')}")
        else:
            print(f"   ❌ 无法获取页面列表: {response.status_code}")
            return False

        # 测试 3: 打开新页面
        print("\n3. 测试打开新页面...")
        response = requests.get(f"{cdp_url}/json/new?https://xkcd.com/353/")
        if response.status_code == 200:
            new_page = response.json()
            print(f"   ✅ 成功打开新页面:")
            print(f"      - URL: {new_page.get('url')}")
            print(f"      - ID: {new_page.get('id')}")
            print(f"      - WebSocket: {new_page.get('webSocketDebuggerUrl')}")
        else:
            print(f"   ❌ 无法打开新页面: {response.status_code}")
            return False

        print("\n" + "=" * 60)
        print("✅ CDP 连接测试通过！")
        print("=" * 60)
        print("\n如果自动化工具仍然报告 CDP 400 错误，可能的原因:")
        print("1. 工具需要 WebSocket 连接，而不是 HTTP")
        print("2. 工具可能连接到错误的端口（非 9222）")
        print("3. 工具可能需要特定的 CDP 版本支持")
        print("4. 可能存在权限或安全策略限制")
        print("\n建议:")
        print("• 检查自动化工具的日志，查看具体错误信息")
        print("• 确认工具连接的端口号是 9222")
        print("• 尝试重启自动化工具")
        print("• 检查是否有防火墙或代理阻止连接")

        return True

    except requests.exceptions.ConnectionError:
        print("\n❌ 无法连接到 CDP 端点")
        print("   确认 Chrome 是否使用 --remote-debugging-port=9222 启动")
        return False
    except Exception as e:
        print(f"\n❌ 测试失败: {e}")
        return False

if __name__ == "__main__":
    test_cdp_connection()
