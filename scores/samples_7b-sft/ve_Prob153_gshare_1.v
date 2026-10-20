
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
    input [6:0] train_history,
    input [6:0] train_pc
);

    reg [6:0] ghr;
    reg [1:0] pht [0:127];
 

    
    wire [6:0] predict_index = predict_pc ^ ghr;
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    always @* begin
        if (predict_valid) begin
            predict_taken_reg = pht[predict_index][1];
            predict_history_reg = ghr;
        end else begin
            predict_taken_reg = 1'b0;
            predict_history_reg = 7'b0;
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            ghr <= 7'b0;
            for (integer i = 0;
 i < 128;
 i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            
            if (train_valid) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[6:0], predict_pc[0]};
            end

            
            if (train_valid) begin
                
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] != 2'b11) begin
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
                    end
                end else begin
                    if (pht[train_pc ^ train_history] != 2'b00) begin
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
                    end
                end
            end
        end
    end

endmodule
