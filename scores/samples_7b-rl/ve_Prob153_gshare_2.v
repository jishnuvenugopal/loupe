
module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_pc,
    input [6:0] train_history
);

    reg [6:0] history_reg;
    reg [1:0] pht [0:127];
 

    
    wire [6:0] pred_index = predict_pc ^ history_reg;
    assign predict_taken = pht[pred_index][1];
 
    assign predict_history = history_reg;

    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            history_reg <= 7'b0;
        end
        else begin
            if (train_valid) begin
                
                integer idx;
                idx = train_pc ^ train_history;

                
                if (train_taken) begin
                    if (pht[idx] != 2'b11)
                        pht[idx] <= pht[idx] + 1;
                end
                else begin
                    if (pht[idx] != 2'b00)
                        pht[idx] <= pht[idx] - 1;
                end

                
                history_reg <= { history_reg[5:0], train_taken };
            end
        end
    end

endmodule
