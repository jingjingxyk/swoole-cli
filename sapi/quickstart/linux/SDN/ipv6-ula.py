
import random
import ipaddress

def generate_ula_address(count=5):
    """
    生成符合RFC4193标准的唯一本地IPv6地址
    :param count: 生成数量，默认5个
    :return: 规范的IPv6地址列表
    """
    results = []
    for _ in range(count):
        # 生成40位全局ID和16位子网ID
        global_subnet = random.getrandbits(56)
        # 生成64位接口标识符
        interface_id = random.getrandbits(64)

        # 组合成完整地址并标准化
        addr = f"fd{global_subnet:014x}:{interface_id:016x}"
        addr = ":".join([addr[i:i+4] for i in range(0, len(addr), 4)])
        results.append(str(ipaddress.IPv6Address(addr)))

    return results

if __name__ == "__main__":
    for addr in generate_ula_address():
        print(addr)
