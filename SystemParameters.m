%% 系统参数初始化
% 功能：定义通信系统、雷达系统和优化参数
% 输入：无
% 输出：包含所有系统参数的结构体Prms
% 注意：所有参数单位需保持一致

function Prms = SystemParameters()
    %% 通信系统参数
    Prms.N = 32;        % RIS单元总数
    Prms.blk_size = 4;  % 块对角矩阵的块大小（必须能整除N）
    Prms.M = 8;         % 基站发射天线数
    Prms.K = 4;         % 用户设备数量
    
    %% 通信QoS参数
    Prms.Gamma_dB = 10;         % 用户最低SINR要求(dB)
    Prms.sigma_c = 1e-9;        % 通信接收机噪声功率(W)
    
    %% 雷达感知参数
    Prms.SNR_dB = 20;           % 雷达检测SNR阈值(dB)
    Prms.sigma_r = 1e-9;        % 雷达接收机噪声功率(W)
    Prms.R = 4;                 % 雷达接收天线数
    
    %% 优化控制参数
    Prms.max_iter = 50;         % 最大交替优化次数
    Prms.tol = 1e-4;            % 收敛判断阈值
end