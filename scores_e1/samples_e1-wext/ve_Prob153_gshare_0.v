
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

    
    reg [6:0] branch_history;

    
    reg [6:0] pht [0:127];

    
    reg [1:0] branch_history_counters [0:127];

    
    reg reset;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            reset <= 1'b1;
            branch_history <= 7'b0;
            branch_history_counters <= 8'b0;
            pht <= 128'b0;
        end else begin
            reset <= 1'b0;
            branch_history <= branch_history;
            branch_history_counters <= branch_history_counters;
            pht <= pht;
        end
    end

    
    always @(posedge clk) begin
        if (predict_valid) begin
            
            predict_taken <= branch_history_counters[predict_pc] == 2'b11;

            
            branch_history_counters[predict_pc] <= branch_history_counters[predict_pc] + 1'b1;
            if (branch_history_counters[predict_pc] == 2'b10) begin
                branch_history_counters[predict_pc] <= 2'b00;
            end
        end
    end

    
    always @(posedge clk) begin
        if (train_valid) begin
            
            if (train_mispredicted) begin
                
                branch_history <= train_history;
                branch_history_counters[train_pc] <= 2'b00;
            end else begin
                
                pht[train_pc] <= pht[train_pc] | train_history;
            end
        end
    end

endmodule
