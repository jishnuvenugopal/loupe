
module TopModule (
    input wire clk,
    input wire areset,
    input wire predict_valid,
    input wire predict_taken,
    input wire train_mispredicted,
    input wire train_taken,
    input wire [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 0;
        end else begin
            if (predict_valid) begin
                history <= {predict_taken, history[31:1]};
            end else if (train_mispredicted) begin
                history <= train_history;
            end
        end
    end

    assign predict_history = history;

endmodule
