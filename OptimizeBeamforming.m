%% 波束成形优化
% 功能：在给定RIS配置下优化发射波束成形矩阵
% 输入：Prms - 参数, Channel - 信道, Phi - 当前RIS配置
% 输出：W - 最优波束成形矩阵
% 算法：二阶锥规划(SOCP)

%% 修改后的OptimizeBeamforming.m
function W = OptimizeBeamforming(Prms, Channel, Phi)
    cvx_clear;
    cvx_begin quiet
        variable W(Prms.M, Prms.K) complex
        variable t  % 松弛变量
        
        % 带惩罚项的目标函数
        minimize(norm(W, 'fro') + Prms.penalty_weight * t)
        
        % 通信QoS约束
        for k = 1:Prms.K
            h_k = Channel.Hdt(:,k) + Channel.G' * Phi' * Channel.Hrt(:,k);
            sqrt_gamma = sqrt(10^(Prms.Gamma_dB/10));
            
            interference = 0;
            for j = [1:k-1, k+1:Prms.K]
                interference = interference + h_k' * W(:,j);
            end
            
            norm([interference; sqrt(Prms.sigma_c)]) <= (1/sqrt_gamma) * real(h_k' * W(:,k));
            imag(h_k' * W(:,k)) == 0;
        end
        
        % 重构后的雷达约束
        H_eff = Channel.H_radar + Channel.G_radar' * Phi' * Channel.H_ris_radar;
        norm(H_eff * W, 'fro') >= sqrt(10^(Prms.SNR_dB/10) * Prms.sigma_r) - t;
        t >= 0;
    cvx_end
    
    % 调试输出
    if strcmp(cvx_status, 'Solved')
        fprintf('优化成功，松弛量t=%.2e\n', t);
    end
end