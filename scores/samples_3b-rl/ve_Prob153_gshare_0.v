
module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input  [6:0] predict_pc,
    output reg   predict_taken,
    output reg [6:0] predict_history,
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    
    reg [6:0] branch_history;

    
    reg [1:0] pht [127:0];

    
    wire [6:0] hash = {1'b0, predict_pc} ^ branch_history;

    
    wire [1:0] pht_read;
    assign pht_read = pht[hash];
    reg [1:0] prediction;
    always @(*) begin
        if (pht_read == 2'b11)
            prediction = 2'b11;
        else if (pht_read == 2'b10)
            prediction = 2'b10;
        else if (pht_read == 2'b01)
            prediction = 2'b01;
        else
            prediction = 2'b00;
    end

    
    always @(posedge clk) begin
        if (train_valid) begin
            
            pht[hash] <= (train_taken) ? 2'b11 : 2'b00;

            
            if (train_mispredicted) begin
                branch_history <= {branch_history[5:0], ~branch_history[6]};
            end else begin
                branch_history <= train_history;
            end
        end else if (predict_valid) begin
            
            predict_taken <= prediction;
            predict_history <= branch_history;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            branch_history <= 7'b0;
        
    end

endmodule
