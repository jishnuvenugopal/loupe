
module TopModule (
    input  clk,
    input  areset,

    input  predict_valid,
    input  predict_pc [6:0],
    output predict_taken,
    output predict_history [6:0],

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  train_history [6:0],
    input  train_pc [6:0]
);

    
    localparam PHT_SIZE = 128;
    localparam HISTORY_SIZE = 7;

    
    reg [6:0] global_history;
    reg [PHT_SIZE-1:0] pht;

    
    function [6:0] calculate_index(input [6:0] pc, input [6:0] history);
        calculate_index = pc ^ history;
    endfunction

    
    function [1:0] saturating_increment(input [1:0] value);
        if (value == 3'b11) begin
            saturating_increment = 3'b11;
        end else begin
            saturating_increment = value + 1;
        end
    endfunction

    
    function [1:0] saturating_decrement(input [1:0] value);
        if (value == 3'b00) begin
            saturating_decrement = 3'b00;
        end else begin
            saturating_decrement = value - 1;
        end
    endfunction

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            pht <= 128'b0;
        end else begin
            if (predict_valid) begin
                
                reg [6:0] index = calculate_index(predict_pc, global_history);

                
                reg [1:0] pht_entry = pht[index];

                
                predict_taken <= (pht_entry == 2'b11);
                predict_history <= global_history;

                
                if (predict_taken) begin
                    global_history <= global_history << 1;
                    global_history[6] <= predict_taken;
                end else begin
                    global_history <= global_history << 1;
                end
            end

            if (train_valid) begin
                
                reg [6:0] index = calculate_index(train_pc, global_history);

                
                reg [1:0] pht_entry = pht[index];

                
                if (train_mispredicted) begin
                    
                    global_history <= train_history;
                end else begin
                    
                    if (train_taken) begin
                        pht_entry = saturating_increment(pht_entry);
                    end else begin
                        pht_entry = saturating_decrement(pht_entry);
                    end
                end

                
                pht[index] <= pht_entry;
            end
        end
    end

endmodule
