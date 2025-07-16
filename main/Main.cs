using Godot;

/// <summary>
/// Main class that executes when the game launches
/// </summary>
public partial class Main : Node3D {
	[Export]
	private Node3D player;
	[Export]
	private Camera3D camera3D;

	private Tween tween;

	public override void _Ready() { }

	/// <summary>
	/// Called once per frame. Handle player click-to-move logic
	/// </summary>
	/// <param name="delta">Time elapsed since the previous frame.</param>
	public override void _Process(double delta) {
		if (Input.IsActionJustPressed("left_click")) {
			// prevent starting a new tween if one is already running
			if (tween != null && tween.IsRunning())
				return;

			Vector3 playerPos = player.GlobalTransform.Origin;
			Vector3 worldPos = GetMouseXZPlanePosition();

			// determine the player's direction of movement
			Vector3 direction = worldPos - playerPos;
			direction.Y = 0f;

			// ignore tiny clicks
			if (direction.Length() < 0.1f)
				return;

			// normalize the direction so player only moves 1 unit
			direction = direction.Normalized();

			// rotate the player to face its direction of movement
			if (direction.Length() > 0.001f)
				player.Rotation = new Vector3(0f, Mathf.Atan2(direction.X, direction.Z), 0);

			Vector3 targetPos = playerPos + direction;

			// animate the player sliding into its new position
			tween = GetTree().CreateTween();
			tween.TweenProperty(player, "global_transform:origin", targetPos, 0.5f)
				.SetTrans(Tween.TransitionType.Sine)
				.SetEase(Tween.EaseType.InOut);
		}
	}

	/// <summary>
	/// Casts a ray from the mouse cursor and returns the intersection point with the XZ plane
	/// </summary>
	/// <returns>The 3D world position under the mouse cursor in the XZ plane.</returns>
	public Vector3 GetMouseXZPlanePosition() {
		Vector2 mousePos = GetViewport().GetMousePosition();
		Vector3 rayStart = camera3D.ProjectRayOrigin(mousePos);
		Vector3 rayDirection = camera3D.ProjectRayNormal(mousePos);

		float t = -rayStart.Y / rayDirection.Y;
		return rayStart + rayDirection * t;
	}
}
