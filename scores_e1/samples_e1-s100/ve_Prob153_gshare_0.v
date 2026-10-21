
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

    
    reg [6:0] gshare_index;
    reg [6:0] gshare_history;
    reg [1:0] gshare_table [0:127];
    reg [6:0] branch_history;
    reg [1:0] branch_table [0:127];

    
    reg [6:0] pht [0:127];
    reg [6:0] pht_index;
    reg [1:0] pht_table [0:127];

    
    reg reset;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            gshare_index <= 7'b0;
            gshare_history <= 7'b0;
            branch_history <= 7'b0;
            pht_index <= 7'b0;
            reset <= 1'b1;
        end else begin
            reset <= 1'b0;
        end
    end

    
    always @(posedge clk) begin
        if (predict_valid) begin
            gshare_index <= predict_pc[6:0];
            gshare_history <= branch_history;
            predict_taken <= gshare_table[gshare_index];
            branch_history <= gshare_history + 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (train_valid) begin
            pht_index <= train_pc[6:0];
            pht_table[pht_index] <= {train_taken, train_mispredicted};
            if (train_mispredicted) begin
                branch_history <= train_history;
            end
        end
    end

    
    always @(posedge clk) begin
        if (pht_index < 128) begin
            pht[pht_index] <= pht_table[pht_index];
        end
    end

    
    always @(posedge clk) begin
        if (gshare_index < 128) begin
            gshare_table[gshare_index] <= {predict_taken, gshare_history[6:0]};
        end
    end

endmodule
