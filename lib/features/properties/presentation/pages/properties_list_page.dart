import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';
import 'package:property_manager/shared/widgets/custom_app_bar.dart';
import 'package:property_manager/shared/widgets/error_widget.dart';
import 'package:property_manager/shared/widgets/loading_widget.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import '../widgets/property_card.dart';
import 'add_property_page.dart';
import 'property_detail_page.dart';

class PropertiesListPage extends StatefulWidget {
  const PropertiesListPage({super.key});

  @override
  State<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends State<PropertiesListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Available',
    'Occupied',
    'Maintenance',
    'Renovating',
  ];

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  void _loadProperties() {
    context.read<PropertyBloc>().add(GetPropertiesEvent());
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
    _performSearch();
  }

  void _onFilterChanged(String? filter) {
    if (filter != null) {
      setState(() {
        _selectedFilter = filter;
      });
      _performSearch();
    }
  }

  void _performSearch() {
    context.read<PropertyBloc>().add(
      SearchPropertiesEvent(
        _searchQuery,
        filterStatus: _selectedFilter == 'All' ? null : _selectedFilter,
      ),
    );
  }

  void _navigateToAddProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPropertyPage()),
    );

    if (result == true) {
      _loadProperties();
    }
  }

  void _navigateToPropertyDetail(Property property) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailPage(property: property),
      ),
    );

    if (result == true) {
      _loadProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Properties',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddProperty,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search properties...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Dropdown
                Row(
                  children: [
                    const Text(
                      'Filter by status: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        onChanged: _onFilterChanged,
                        items:
                        _filterOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Properties List
          Expanded(
            child: BlocBuilder<PropertyBloc, PropertyState>(
              builder: (context, state) {
                if (state is PropertyLoading) {
                  return const LoadingWidget();
                }

                if (state is PropertyError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: _loadProperties,
                  );
                }

                if (state is PropertiesLoaded) {
                  final properties = state.properties;

                  if (properties.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty || _selectedFilter != 'All'
                                ? 'No properties match your criteria'
                                : 'No properties added yet',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty || _selectedFilter != 'All'
                                ? 'Try adjusting your search or filter'
                                : 'Tap the + button to add your first property',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadProperties(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PropertyCard(
                            property: property,
                            onTap: () => _navigateToPropertyDetail(property),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProperty,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
