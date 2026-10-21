
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
    reg [1:0] gshare_predict_taken;
    reg [1:0] gshare_predict_history;

    
    reg [6:0] pht [0:127];
    reg [6:0] pht_index;
    reg [6:0] pht_history;
    reg [1:0] pht_predict_taken;
    reg [1:0] pht_predict_history;

    
    reg [6:0] branch_history;

    
    reg reset;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            gshare_index <= 7'b0;
            gshare_history <= 7'b0;
            gshare_predict_taken <= 2'b0;
            gshare_predict_history <= 2'b0;
            pht_index <= 7'b0;
            pht_history <= 7'b0;
            pht_predict_taken <= 2'b0;
            pht_predict_history <= 2'b0;
            branch_history <= 7'b0;
            reset <= 1'b1;
        end else begin
            reset <= 1'b0;
        end
    end

    
    always @(posedge clk) begin
        if (predict_valid) begin
            
            gshare_index <= predict_pc[6:0];
            gshare_history <= branch_history;
            gshare_predict_taken <= pht[gshare_index][0];
            gshare_predict_history <= pht[gshare_index][1];

            
            branch_history <= predict_pc[6:0];
        end
    end

    
    always @(posedge clk) begin
        if (train_valid) begin
            
            pht_index <= train_pc[6:0];
            pht_history <= train_history;
            pht_predict_taken <= train_taken;
            pht_predict_history <= train_mispredicted;

            
            if (train_taken) begin
                pht[pht_index][0] <= pht_predict_taken;
                pht[pht_index][1] <= pht_predict_history;
            end
        end
    end

endmodule
