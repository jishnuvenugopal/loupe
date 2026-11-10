
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
    reg [6:0] gshare_table [0:127];
    reg [1:0] gshare_table_entry [0:127];

    
    reg [6:0] branch_history;

    
    reg [6:0] pht [0:127];
    reg [6:0] pht_entry [0:127];

    
    reg reset;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            gshare_index <= 7'b0;
            gshare_history <= 7'b0;
            gshare_table <= 128'b0;
            gshare_table_entry <= 128'b0;
            branch_history <= 7'b0;
            pht <= 128'b0;
            pht_entry <= 128'b0;
            reset <= 1'b1;
        end else begin
            reset <= 1'b0;

            
            gshare_index <= {predict_pc[6:0], gshare_history[6:0]};

            
            gshare_history <= {predict_pc[6:0], gshare_history[5:0]};

            
            gshare_table[gshare_index] <= gshare_table_entry[gshare_index];

            
            branch_history <= {predict_pc[6:0], branch_history[5:0]};

            
            pht[pht_entry[gshare_index]] <= {predict_pc[6:0], branch_history[6:0]};
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            predict_taken <= gshare_table_entry[gshare_index];
            predict_history <= branch_history;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            train_mispredicted <= 1'b0;
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    
                    branch_history <= train_history;
                end else begin
                    
                    pht[pht_entry[gshare_index]] <= {train_pc[6:0], train_history[6:0]};
                end
            end
        end
    end

endmodule
