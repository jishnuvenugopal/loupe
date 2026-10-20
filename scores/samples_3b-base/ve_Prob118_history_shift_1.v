
module TopModule (
    input  clk,
    input  areset,
    input  predict_valid,
    input  predict_taken,
    input  train_mispredicted,
    input  train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    
    reg [31:0] global_history;

    
    always @(posedge areset) begin
        global_history <= 32'b0;
 
    end

    
    always @(posedge clk) begin
        if (predict_valid && !train_mispredicted) begin
            
            global_history <= {global_history[30:0], predict_taken};
        end
    end

    
    always @(posedge clk) begin
        if (train_mispredicted) begin
            
            global_history <= {train_history, train_taken};
        end
    end

    
    assign predict_history = global_history;

endmodule
