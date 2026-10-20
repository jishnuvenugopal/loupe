
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

    
    reg [6:0] global_history;

    
    reg [1:0] pht [127];

    
    always @(*) begin
        if (1'b1)
            pht[7 ^ global_history] = (pht[7 ^ global_history] + 2'b01) < 2'b11 ? (pht[7 ^ global_history] + 2'b01) : 2'b11;
        else
            pht[7 ^ global_history] = 2'b00;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else if (predict_valid) begin
            
            reg [6:0] index = predict_pc ^ global_history;
            
            reg [1:0] pht_value = pht[index];
            
            predict_taken   <= (pht_value == 2'b11);
            
            predict_history <= predict_taken ? (global_history + 1'b1) : global_history;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            pht <= 128'd0;
            global_history <= 7'b0;
        end else if (train_valid) begin
            
            reg [6:0] index = train_pc ^ global_history;
            
            if (train_mispredicted) begin
                pht[index] <= 2'b00;
                global_history <= train_history;
            end else begin
                
                pht[index] <= (pht[index] + 2'b01) < 2'b11 ? (pht[index] + 2'b01) : 2'b11;
            end
        end
    end

endmodule
