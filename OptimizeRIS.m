%% RIS矩阵优化
% 功能：在块对角约束下优化RIS配置矩阵
% 输入：Prms - 参数, Channel - 信道, W - 当前波束成形
% 输出：Phi - 最优RIS配置
% 约束：块对角正交性

function Phi = OptimizeRIS(Prms, Channel, W)
    cvx_begin quiet
        variable Phi(Prms.N, Prms.N) complex  % RIS配置矩阵
        
        % === 块对角正交约束 ===
        num_blks = Prms.N / Prms.blk_size;
        for blk = 1:num_blks
            idx = (blk-1)*Prms.blk_size+1 : blk*Prms.blk_size;
            Phi_blk = Phi(idx, idx);
            Phi_blk * Phi_blk' == eye(Prms.blk_size);  % 正交性约束
        end
        
        % === 目标函数：最大化等效信道增益 ===
        H_eff = Channel.Hdt + Channel.G' * Phi' * Channel.Hrt;
        maximize(real(trace(H_eff * W * W' * H_eff')))
    cvx_end
end