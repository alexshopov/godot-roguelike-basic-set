using Godot;

/// <summary>
/// Main class that executes when the game launches
/// </summary>
public partial class Main : Node3D
{
	[Export]
	public Entity Player { get; set; }
	[Export]
	public Camera3D Camera { get; set; }

	public override void _Ready() { }

	/// <summary>
	/// Called in response to an input event. Handle player click-to-move logic
	/// </summary>
	/// <param name="@event">The captured input event.</param>
	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("left_click"))
		{
			Vector3 worldPos = GetMouseXZPlanePosition();
			Player.MoveTo(worldPos);
		}
	}

	/// <summary>
	/// Casts a ray from the mouse cursor and returns the intersection point with the XZ plane
	/// </summary>
	/// <returns>The 3D world position under the mouse cursor in the XZ plane.</returns>
	public Vector3 GetMouseXZPlanePosition()
	{
		Vector2 mousePos = GetViewport().GetMousePosition();
		Vector3 rayStart = Camera.ProjectRayOrigin(mousePos);
		Vector3 rayDirection = Camera.ProjectRayNormal(mousePos);

		float t = -rayStart.Y / rayDirection.Y;
		return rayStart + rayDirection * t;
	}
}
