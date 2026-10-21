
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

    
    reg [6:0] pc;
    reg [6:0] global_history;

    
    reg [6:0] index;

    
    reg [1:0] table [0:127];

    
    reg [6:0] branch_history;

    
    reg [1:0] pht [0:127];

    
    reg reset;

    
    reg clk_en;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pc <= 7'b0;
            global_history <= 7'b0;
            index <= 7'b0;
            table <= 128'b0;
            branch_history <= 7'b0;
            pht <= 128'b0;
            reset <= 1'b1;
            clk_en <= 1'b0;
        end else begin
            pc <= predict_pc;
            global_history <= global_history;
            index <= pc[6:0] ^ global_history[6:0];
            table[index] <= table[index] + 1'b1;
            branch_history <= branch_history;
            pht[index] <= pht[index];
            reset <= 1'b0;
            clk_en <= 1'b1;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pc <= 7'b0;
            global_history <= 7'b0;
            index <= 7'b0;
            table <= 128'b0;
            branch_history <= 7'b0;
            pht <= 128'b0;
            reset <= 1'b1;
            clk_en <= 1'b0;
        end else begin
            pc <= train_pc;
            global_history <= global_history;
            index <= pc[6:0] ^ global_history[6:0];
            table[index] <= table[index] + 1'b1;
            branch_history <= branch_history;
            pht[index] <= pht[index];
            reset <= 1'b0;
            clk_en <= 1'b1;
        end
    end

    
    always @(posedge clk or posedge clk_en) begin
        if (predict_valid) begin
            if (table[index] == 2'b11) begin
                predict_taken <= 1'b1;
                predict_history <= branch_history;
            end else begin
                predict_taken <= 1'b0;
                predict_history <= branch_history;
            end
        end
    end

    
    always @(posedge clk or posedge clk_en) begin
        if (train_valid) begin
            if (train_mispredicted) begin
                branch_history <= train_history;
            end
            if (table[index] == 2'b11) begin
                pht[index] <= train_history;
            end
        end
    end

endmodule
