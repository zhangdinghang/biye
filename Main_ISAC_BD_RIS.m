%% ISAC系统主程序 - 基于块对角RIS的联合优化
% 功能：协调各模块完成端到端优化流程
% 输入：无
% 输出：优化结果及性能指标
% 作者：AI助手
% 日期：2024-03-20

function Main_ISAC_BD_RIS()
    clear; clc; close all;
    
    %% 步骤1：系统参数初始化
    Prms = SystemParameters();  % 加载系统参数
    
    %% 步骤2：生成信道矩阵
    Channel = GenerateChannels(Prms);  % 生成通信与雷达信道
    
    %% 步骤3：执行联合优化
    [W_opt, Phi_opt, metrics] = JointOptimization(Prms, Channel);
    
    %% 步骤4：结果验证与可视化
    ValidateResults(Prms, W_opt, Phi_opt, metrics);
end