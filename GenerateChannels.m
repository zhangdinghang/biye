%% 信道矩阵生成
% 功能：生成符合块对角结构的RIS信道矩阵
% 输入：Prms - 系统参数结构体
% 输出：Channel - 包含所有信道矩阵的结构体
% 注意：采用瑞利衰落信道模型

function Channel = GenerateChannels(Prms)
    %% 通信信道
    % 基站-用户直连信道 (MxK)
    Channel.Hdt = (randn(Prms.M, Prms.K) + 1j*randn(Prms.M, Prms.K))/sqrt(2);
    
    %% RIS相关信道（块对角结构）
    Channel.Hrt = zeros(Prms.N, Prms.K);
    num_blks = Prms.N / Prms.blk_size;
    for blk = 1:num_blks
        idx = (blk-1)*Prms.blk_size+1 : blk*Prms.blk_size;
        % 生成正交块矩阵
        [Q, ~] = qr(randn(Prms.blk_size) + 1j*randn(Prms.blk_size));
        Channel.Hrt(idx, :) = Q * randn(Prms.blk_size, Prms.K)/sqrt(2);
    end
    
    % 基站-RIS信道 (NxM)
    Channel.G = (randn(Prms.N, Prms.M) + 1j*randn(Prms.N, Prms.M))/sqrt(2);
    
    %% 雷达信道
    % 基站-雷达直连信道 (RxM)
    Channel.H_radar = (randn(Prms.R, Prms.M) + 1j*randn(Prms.R, Prms.M))/sqrt(2);
    
    % RIS-雷达信道 (NxR)
    Channel.G_radar = (randn(Prms.N, Prms.R) + 1j*randn(Prms.N, Prms.R))/sqrt(2);
    Channel.H_ris_radar = (randn(Prms.N, Prms.M) + 1j*randn(Prms.N, Prms.M))/sqrt(2);


    % 维度验证
    assert(size(Channel.H_ris_radar,1)==Prms.N && size(Channel.H_ris_radar,2)==Prms.M, ...
        'H_ris_radar维度错误，应为%d x %d', Prms.N, Prms.M);
    assert(size(Channel.G_radar,1)==Prms.N && size(Channel.G_radar,2)==Prms.R, ...
        'G_radar维度错误，应为%d x %d', Prms.N, Prms.R);
end