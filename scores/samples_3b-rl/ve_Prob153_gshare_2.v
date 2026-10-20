
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

    
    reg [6:0] history;

    
    wire [6:0] index;
    assign index = predict_pc ^ history;

    
    reg [1:0] counter;

    
    reg [1:0] pht [127:0];

    
    wire [6:0] pht_addr;

    
    assign pht_addr = index;

    
    reg [1:0] pht_value;
    always @(posedge clk) begin
        if (areset) begin
            pht_value <= 2'b00;
        end else begin
            pht_value <= pht[pht_addr];
        end
    end

    
    always @(posedge clk) begin
        if (areset) begin
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
            counter <= 2'b00;
        end else begin
            if (predict_valid) begin
                
                counter <= pht_value;

                
                predict_taken <= (counter > 2'b00);

                
                if (predict_taken)
                    history <= history + 1'b1;
                else
                    history <= history + 1'b0;
            end
        end
    end

    
    always @(posedge clk) begin
        if (areset) begin
            counter <= 2'b00;
            history <= 7'b0;
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    
                    history <= train_history;
                end else begin
                    
                    pht[pht_addr] <= pht_value + 2'b01;

                    
                    if (train_taken)
                        history <= history + 1'b1;
                    else
                        history <= history + 1'b0;
                end
            end
        end
    end

endmodule
