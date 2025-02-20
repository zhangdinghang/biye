%% 收敛性判断
% 功能：根据优化指标判断是否达到收敛条件
% 输入：metrics - 优化指标, tol - 阈值, iter - 当前迭代次数
% 输出：converged - 是否收敛标志

function converged = CheckConvergence(metrics, tol, iter)
    converged = false;
    
    if iter > 1
        % 计算功率变化量
        power_change = abs(metrics.power(end) - metrics.power(end-1));
        
        % 计算RIS矩阵变化量
        phi_change = metrics.delta_phi(end);
        
        % 双重收敛条件
        if power_change < tol && phi_change < tol
            converged = true;
        end
    end
end