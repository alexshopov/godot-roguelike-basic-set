using Godot;
using System;
using System.Collections.Generic;

public partial class EntityManager : Node
{
    [Export]
    public PackedScene PlayerScene { get; set; }
    [Export]
    public PackedScene SkeletonScene { get; set; }

    private Entity _player;
    private HashSet<Entity> _entities = [];

    public override void _Ready()
    {
        _player = PlayerScene.Instantiate<Entity>();
        AddChild(_player);

        var skeleton = SkeletonScene.Instantiate<Entity>();
        AddChild(skeleton);
        skeleton.GlobalPosition = new Vector3(-2f, 0f, -1f);

        _entities.Add(_player);
        _entities.Add(skeleton);

        EventManager.MouseClickedInWorld += OnMouseClickedInWorld;
    }

    public override void _ExitTree()
    {
        EventManager.MouseClickedInWorld -= OnMouseClickedInWorld;
    }

    private void OnMouseClickedInWorld(Vector3 worldPos)
    {
        _player?.MoveTo(worldPos);
    }
}
