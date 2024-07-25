import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({required this.tag, super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      inverted: true,
      horizontal: 10,
      vertical: 0,
      child: Text(
        tag,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).inverseTextColor,
          fontSize: 14,
        ),
      ),
    );
  }
}

class TagListWidget extends StatelessWidget {
  const TagListWidget({required this.tags, super.key});
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((item) {
        return TagWidget(tag: item);
      }).toList(),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    required this.inverted,
    required this.horizontal,
    required this.vertical,
    required this.child,
    super.key,
  });

  final bool inverted;
  final double? horizontal;
  final double? vertical;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: inverted == true
          ? Theme.of(context).accentColor
          : Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor,
      borderRadius: defaultBorderRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        child: child,
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    required this.label,
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const HorizontalSpacer(),
        Expanded(
          child: CustomContainer(
            inverted: false,
            horizontal: null,
            vertical: 0,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      text,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).accentColor,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  // splashColor: Colors.transparent,
                  // highlightColor: Colors.transparent,
                  tooltip: 'Edit',
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    required this.text,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // section name
              Text(
                label,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.settings),
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
          // text
          Text(text),
        ],
      ),
    );
  }
}

class CustomTabWidget extends StatelessWidget {
  const CustomTabWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tab(child: child);
  }
}

class CustomTabBarWidget extends StatelessWidget {
  const CustomTabBarWidget({required this.tabs, super.key});
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: defaultBorderRadius,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: defaultBorderRadius,
        ),
        labelColor: Theme.of(context).textColor,
        unselectedLabelColor: Theme.of(context).subtextColor,
        tabs: tabs,
      ),
    );
  }
}

class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: defaultSpacing);
  }
}

class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: defaultSpacing);
  }
}