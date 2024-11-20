import numpy as np


def strobe_like(M1, M2):
    M = np.empty_like(M1)
    M[::2, 1::2] = M1[::2, 1::2]
    M[1::2, ::2] = M1[1::2, ::2]
    M[::2, ::2] = M2[::2, ::2]
    M[1::2, 1::2] = M2[1::2, 1::2]
    return M


def init_txt():
    with open('matrix_A.txt', 'w'):
        pass
    with open('matrix_B.txt', 'w'):
        pass
    with open('matrix_C.txt', 'w'):
        pass
    with open('matrix_F.txt', 'w'):
        pass


BW, DW = 64, 16
MD = int(BW / DW)
if BW == 16:
    int_type = np.int16
elif BW == 32:
    int_type = np.int32
else:  # BW==64
    int_type = np.int64
max_elm = 2 ** (DW - 1)
min_elm = -2 ** (DW - 1)
max_res = 2 ** (BW - 1)
min_res = -2 ** (BW - 1)
A = B = F = np.zeros((MD, MD), dtype=np.int64)
C = np.zeros((MD, MD), dtype=np.int64)
init_txt()
for i in range(0, 1000):
    A_c = A.copy()  # save A from prev iter to simulate strobe
    B_c = B.copy()  # save B from prev iter to simulate strobe
    A = np.random.randint(low=min_elm, high=max_elm, size=(MD, MD), dtype=np.int64)
    B = np.random.randint(low=min_elm, high=max_elm, size=(MD, MD), dtype=np.int64)
    with open('matrix_A.txt', 'a') as file_A:  # write A to txt
        file_A.write(','.join(map(str, A.flatten())))
        file_A.write('\n')
    with open('matrix_B.txt', 'a') as file_B:  # write B to txt
        file_B.write(','.join(map(str, B.flatten())))
        file_B.write('\n')
    if i % 3 == 2:  # every 3 iteration apply strobe simulation
        A = strobe_like(A_c, A)  # simulate strobe to be like
        B = strobe_like(B_c, B)  # chess pattern with prev matrix

    np.where((np.dot(A, B) > max_res) | (np.dot(A, B) < min_res), 1, 0)

    C = (i % 2) * C + np.dot(A, B)
    F = np.where((C > max_res) | (C < min_res), 1, 0)
    C = C.astype(int_type)

    with open('matrix_C.txt', 'a') as file_C:
        file_C.write(','.join(map(str, C.flatten())))
        file_C.write('\n')
    with open('matrix_F.txt', 'a') as file_f:
        file_f.write(','.join(map(str, F.flatten())))
        file_f.write('\n')


