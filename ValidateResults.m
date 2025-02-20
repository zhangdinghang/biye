%% 结果验证与可视化
% 功能：验证优化结果并绘制收敛曲线
% 输入：Prms - 参数, W - 波束成形, Phi - RIS配置, metrics - 指标

function ValidateResults(Prms, W, Phi, metrics)
    %% 基础验证
    fprintf('\n=== 结果验证 ===\n');
    fprintf('最终发射功率: %.4f W\n', norm(W, 'fro')^2);
    
    %% RIS正交性验证
    ortho_err = 0;
    num_blks = Prms.N / Prms.blk_size;
    for blk = 1:num_blks
        idx = (blk-1)*Prms.blk_size+1 : blk*Prms.blk_size;
        ortho_err = ortho_err + norm(Phi(idx,idx)*Phi(idx,idx)' - eye(Prms.blk_size), 'fro');
    end
    fprintf('RIS块对角正交性误差: %.2e\n', ortho_err);
    
    %% 可视化
    figure('Name','优化过程监控','Position',[100 100 800 600])
    
    % 发射功率曲线
    subplot(2,1,1);
    plot(metrics.power, 'LineWidth', 2, 'Marker','o');
    title('发射功率收敛曲线');
    xlabel('迭代次数'); ylabel('功率(W)');
    grid on;
    
    % RIS变化量曲线
    subplot(2,1,2);
    semilogy(metrics.delta_phi, 'LineWidth', 2, 'Color','r', 'Marker','s');
    title('RIS配置变化量');
    xlabel('迭代次数'); ylabel('Frobenius范数');
    grid on;
end