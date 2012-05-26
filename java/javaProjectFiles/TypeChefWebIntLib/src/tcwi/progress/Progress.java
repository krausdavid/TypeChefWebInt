package tcwi.progress;

public class Progress {
	private int currentStatus;
	private int maxTicks;
	private int tickSize;
	private double border;
	
	public Progress(int tickSize, int maxTicks){
		this.tickSize = tickSize;
		this.currentStatus = 0;
		this.maxTicks = maxTicks;
	}
	
	public double tick(){
		this.currentStatus++;
		for(double d=0;d<(100/tickSize);d++){
			if(((this.currentStatus/this.maxTicks)>=d*tickSize)&&(border != d)){
				border = d;
				return d*tickSize;
			}
		}
		return -1.0;
	}	
	
	public void tickAndPrint(){
		double t = tick();
		if(t!=-1.0){
			System.out.print(t+"%..");
		}
	}
	
	public void reset(){
		this.currentStatus = 0;
		this.border = 0;
	}

}
