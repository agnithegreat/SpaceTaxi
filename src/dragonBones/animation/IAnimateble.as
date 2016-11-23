package dragonBones.animation
{
	/**
	 * @language zh_CN
	 * 播放动画组件接口。 (Armature 和 WordClock 都实现了该接口)
	 * 任何实现了此接口的实例都可以加到 WorldClock 时钟中，由时钟统一控制动画的播放。
	 * @see dragonBones.animation.WorldClock
	 * @see dragonBones.Armature
	 * @version DragonBones 3.0
	 */
	public interface IAnimateble
	{
		/**
		 * @language zh_CN
		 * 更新一个指定的时间。
		 * @param passedTime 前进的时间。 (以秒为单位)
		 * @version DragonBones 3.0
		 */
		function advanceTime(passedTime:Number):void;
	}
}