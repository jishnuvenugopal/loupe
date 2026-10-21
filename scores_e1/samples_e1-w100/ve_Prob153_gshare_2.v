
module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input predict_pc (7 bits),
    output predict_taken,
    output predict_history (7 bits),

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input train_history (7 bits),
    input train_pc (7 bits)
);

    
    function [6:0] gshare_hash(input [7:0] pc, input [7:0] history);
        gshare_hash = pc ^ history;
    endfunction

    
    reg [1:0] counter_table [0:127];

    
    reg [6:0] branch_history;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter_table <= 128'b0;
            branch_history <= 7'b0;
        end else if (predict_valid) begin
            
            predict_taken <= counter_table[gshare_hash(predict_pc, branch_history)];
            
            branch_history <= gshare_hash(predict_pc, branch_history);
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter_table <= 128'b0;
            branch_history <= 7'b0;
        end else if (train_valid) begin
            
            if (train_mispredicted) begin
                
                branch_history <= train_history;
            end
            
            counter_table[gshare_hash(train_pc, train_history)] <= counter_table[gshare_hash(train_pc, train_history)] + 1'b1;
        end
    end

endmodule
