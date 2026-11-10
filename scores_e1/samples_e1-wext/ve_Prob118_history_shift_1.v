
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input train_history   (32 bits),
    output predict_history (32 bits)
);

    
    reg [31:0] history;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (predict_valid) begin
            history <= history << 1;
            history[0] <= predict_taken;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            history <= train_history;
        end
    end

    
    assign predict_history = history;

endmodule
