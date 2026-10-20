
module TopModule (
    input wire clk,
    input wire areset,
    input wire predict_valid,
    input wire [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,
    input wire train_valid,
    input wire train_taken,
    input wire train_mispredicted,
    input wire [6:0] train_history,
    input wire [6:0] train_pc
);

    reg [6:0] global_history;
    reg [127:0] pht;
    reg [6:0] predicted_history;
    reg [1:0] branch_outcome;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            pht <= 128'b0;
        end else begin
            if (train_valid) begin
                reg [7:0] index;
                index = predict_pc ^ global_history;
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
                case (train_outcome)
                    2'b00: pht[index] <= 2'b00;
                    2'b01: pht[index] <= 2'b01;
                    2'b10: pht[index] <= 2'b10;
                    2'b11: pht[index] <= 2'b11;
                endcase
            end
            if (predict_valid) begin
                reg [7:0] index;
                index = predict_pc ^ global_history;
                predicted_history <= train_history;
                branch_outcome = pht[index];
                predict_taken <= branch_outcome[1];
            end
        end
    end

    always @(posedge clk) begin
        if (predict_valid && train_valid) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            global_history <= predicted_history;
        end
    end

endmodule
