import pandas as pd
from collections import defaultdict

def create_category_hierarchy(filename):
    # 엑셀 파일 읽기
    df = pd.read_excel(filename, engine='openpyxl')
    df = df.fillna(value='')
    
    # 계층적 구조를 저장할 딕셔너리 생성
    category_hierarchy = defaultdict(lambda: defaultdict(set))
    
    # 데이터프레임 순회하며 계층 구조 생성
    for _, row in df.iterrows():
        large = str(row['대분류명']).strip()
        middle = str(row['중분류명']).strip()
        small = str(row['소분류명']).strip()
        if large and middle and small:
            category_hierarchy[large][middle].add(small)
        if large and middle:
            category_hierarchy[large][middle]
        elif large:
            category_hierarchy[large]
        
    
    return category_hierarchy
def print_category_stats(hierarchy):
    large_count = len(hierarchy)
    middle_count = sum(len(middle) for middle in hierarchy.values())
    small_count = sum(len(small) for middle in hierarchy.values() for small in middle.values())
    
    print(f'대분류: {large_count}, 중분류: {middle_count}, 소분류: {small_count}')

def print_hierarchy(hierarchy):
    p = 0
    for large, middle_dict in hierarchy.items():
        m = 0
        p += 1
        print(f"대분류 {str(p)}: {large} | 부모 없음")
        for middle, small_set in middle_dict.items():
            m += 1
            s = 0
            print(f"  중분류 {str(p)+str(m)}: {middle} | 부모 {str(p)}")
            for small in small_set:
                s += 1
                print(f"    소분류{str(p)+str(m)+ str(s)}: {small} 부모id ={str(p)+str(m)}")
        print()
# 메인 실행 코드




import oracledb
# url: jdbc:oracle:thin:@
# (description= 
# (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.ap-chuncheon-1.oraclecloud.com))
# (connect_data=(service_name=g66b19f3607d868_maindb_high.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes))
#)
# username: gbin1
# password: Globalinorcl1
# driver-class-name: oracle.jdbc.OracleDriver
    # (retry_count=20)(retry_delay=3)
    # (address=(protocol=tcps)(port=1522)(host=xxx.oraclecloud.com))
    # (connect_data=(service_name=xxx.adb.oraclecloud.com))
    # (security=(ssl_server_dn_match=yes)))

#     filename = 'category_table.xlsx'
# category_hierarchy = create_category_hierarchy(filename)
# # output_filename = 'category_hierarchy_output.xlsx'

# print_hierarchy(category_hierarchy)
# print_category_stats(category_hierarchy)
cs = '''
(description= 
(retry_count=20)(retry_delay=3)
(address=(protocol=tcps)(port=1522)(host=adb.ap-chuncheon-1.oraclecloud.com))
(connect_data=(service_name=g66b19f3607d868_maindb_high.adb.oraclecloud.com))
(security=(ssl_server_dn_match=yes)))'''
# oracledb.init_oracle_client()
try:
    connection = oracledb.connect (
        dsn=cs,
        user= "gbin1" ,
        password= "Globalinorcl1"
    )
    print("연결성공")
    cursor = connection.cursor()
    cursor.execute('''
    INSERT INTO "category" ("category_id", "name", "path", "super_category_id") 
    VALUES                 (0, '테스트카테고리', '/0/', NULL)
    ''')
    connection.commit()
    # cursor.execute('SELECT * FROM "category"')
    cursor.execute(' select * from "category"')
    views  = cursor.fetchall()
    for view in views:
        print(f"{view}")
except Exception as e:
    print(str(e))