using Godot;
using System;

public partial class Entity : Node3D
{
	[Export]
	public float MoveSpeed { get; set; } = 1f;
	
	private Tween _tween;

    public void MoveTo(Vector3 worldPos)
    {
        // prevent starting a new tween if one is already running
        if (_tween != null && _tween.IsRunning())
            return;

        // determine the player's direction of movement
        Vector3 direction = worldPos - GlobalPosition;
        direction.Y = 0f;

        // ignore tiny clicks
        if (direction.Length() < 0.1f)
            return;

        // normalize the direction so player only moves 1 unit
        direction = direction.Normalized();

        // calculate the target position we want the player to move to
        Vector3 targetPos = GlobalPosition + direction;

        // rotate the player to face its direction of movement
        LookAt(targetPos, Vector3.Up);

        // animate the player sliding into its new position
        _tween = GetTree().CreateTween();
        _tween.TweenProperty(this, "global_position", targetPos, 1 / MoveSpeed)
            .SetTrans(Tween.TransitionType.Sine)
            .SetEase(Tween.EaseType.InOut);
    }
}
