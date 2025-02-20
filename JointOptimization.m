%% 联合优化主函数
% 功能：交替优化波束成形矩阵W和RIS配置矩阵Phi
% 输入：Prms - 系统参数, Channel - 信道矩阵
% 输出：W - 最优波束成形矩阵, Phi - 最优RIS配置, metrics - 优化指标

function [W, Phi, metrics] = JointOptimization(Prms, Channel)
    %% 初始化
    Phi = eye(Prms.N);  % RIS初始配置（单位矩阵）
    metrics = struct(...
        'power', [], ...     % 发射功率记录
        'delta_phi', [] ...  % RIS矩阵变化量
    );
    
    %% 交替优化循环
    for iter = 1:Prms.max_iter
        fprintf('\n=== 交替优化迭代 %d/%d ===\n', iter, Prms.max_iter);
        
        % 步骤1：固定Phi优化W
        W = OptimizeBeamforming(Prms, Channel, Phi);
        current_power = norm(W, 'fro')^2;
        metrics.power(end+1) = current_power;
        
        % 步骤2：固定W优化Phi
        Phi_prev = Phi;
        Phi = OptimizeRIS(Prms, Channel, W);
        delta_phi = norm(Phi - Phi_prev, 'fro');
        metrics.delta_phi(end+1) = delta_phi;
        
        % 收敛判断
        if CheckConvergence(metrics, Prms.tol, iter)
            fprintf('***** 已在%d次迭代后收敛 *****\n', iter);
            break;
        end
    end
end