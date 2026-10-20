
module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    
    wire [6:0] index;
    wire [6:0] new_history;
    wire [6:1] pht_entry;
    wire       pht_taken;
    wire       pht_mispredicted;

    
    reg [127:0] pht;
    reg [6:0]   pht_counter;

    
    reg [6:0] branch_history;

    
    assign index = predict_pc ^ branch_history;

    
    assign pht_entry = pht[index];
    assign pht_taken = (pht_entry == 2'b11);
    assign pht_mispredicted = (pht_entry == 2'b00);

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else if (predict_valid) begin
            
            
            
            
            if (pht_mispredicted) begin
                branch_history <= train_history;
                pht_counter <= pht_counter + 1;
            end else begin
                branch_history <= predict_pc;
                pht_counter <= pht_counter + 1;
            end
            predict_taken <= pht_taken;
            predict_history <= predict_pc;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 7'b0;
            pht <= 128'd0;
        end else if (train_valid) begin
            
            
            
            if (train_mispredicted) begin
                
                branch_history <= 7'b0;
                pht[index] <= 2'b11;
 
            end else begin
                
                if (train_taken) begin
                    pht[index] <= 2'b10;
 
                end else begin
                    pht[index] <= 2'b00;
 
                end
                
                branch_history <= train_pc;
            end
        end
    end

endmodule
