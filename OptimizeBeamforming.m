function W = OptimizeBeamforming(Prms, Channel, Phi)
    cvx_clear;
    cvx_precision high;
    cvx_begin quiet
        variable W(Prms.M, Prms.K) complex
        variable t nonnegative  % 关键修改：显式声明非负
        
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
        
        % 雷达约束（DCP合规形式）
        H_eff = Channel.H_radar + Channel.G_radar' * Phi' * Channel.H_ris_radar;
        norm(H_eff * W, 'fro') + t >= sqrt(10^(Prms.SNR_dB/10) * Prms.sigma_r);
    cvx_end
end