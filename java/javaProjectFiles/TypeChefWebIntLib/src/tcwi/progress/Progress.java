package tcwi.progress;

public class Progress {
	private int currentStatus;
	private int tickSize;
	private int max;
	
	public Progress(int tickSize){
		this.tickSize = tickSize;
		this.currentStatus = 0;
		this.max = 100;
	}
	
	public int tick(){
		this.currentStatus += this.tickSize;
		if(this.tickSize>max){
			this.currentStatus = max;
		}
		return this.currentStatus;
	}

	public int getMax() {
		return max;
	}

	public void setMax(int max) {
		this.max = max;
	}
}
