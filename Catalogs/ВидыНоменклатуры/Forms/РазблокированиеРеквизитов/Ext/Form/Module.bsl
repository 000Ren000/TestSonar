﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Результат = Новый Массив;
	
	Если РазрешитьРедактированиеТипНоменклатуры Тогда
		Результат.Добавить("ТипНоменклатуры");
	КонецЕсли;
	
	Если РазрешитьРедактированиеИспользованиеХарактеристик Тогда
		Результат.Добавить("ИспользоватьХарактеристики");
		Результат.Добавить("ИспользованиеХарактеристик");
		Результат.Добавить("ВладелецХарактеристик");
	КонецЕсли;
	
	Если РазрешитьРедактированиеИспользованияСерий Тогда
		Результат.Добавить("ИспользоватьСерии");
		Результат.Добавить("ПолитикиУчетаСерий");
		Результат.Добавить("НастройкаИспользованияСерий");
		Результат.Добавить("ТочностьУказанияСрокаГодностиСерии");
		Результат.Добавить("ВладелецСерий");
		Результат.Добавить("НастройкиСерийБерутсяИзДругогоВидаНоменклатуры");
		Результат.Добавить("ЕстьИндивидуальныеНастройкиПолитикиУчетаСерий");
	КонецЕсли;
	
	Если РазрешитьРедактированиеВариантаОформленияУслуги Тогда
		Результат.Добавить("ВариантОформленияПродажи");
	КонецЕсли;
	
	Если РазрешитьРедактированиеАлкогольнаяПродукция Тогда
		Результат.Добавить("АлкогольнаяПродукция");
	КонецЕсли;
	
	Если РазрешитьРедактированиеСодержитДрагоценныеМатериалы Тогда
		Результат.Добавить("СодержитДрагоценныеМатериалы");
	КонецЕсли;
	
	Если РазрешитьРедактированиеНастроекНабора Тогда
		Результат.Добавить("ВариантПредставленияНабораВПечатныхФормах");
		Результат.Добавить("ВариантРасчетаЦеныНабора");
	КонецЕсли;
	
	Если РазрешитьРедактированиеВариантаЗаданияТоварныхКатегорий Тогда
		Результат.Добавить("ТоварныеКатегорииОбщиеСДругимВидомНоменклатуры");
		Результат.Добавить("ВладелецТоварныхКатегорий");
	КонецЕсли;
	
	Если РазрешитьРедактированиеЦенообразование Тогда
		Результат.Добавить("НастройкиКлючаЦенПоХарактеристике");
		Результат.Добавить("НастройкиКлючаЦенПоСерии");
		Результат.Добавить("НастройкиКлючаЦенПоУпаковке");
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры // РазрешитьРедактирование()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РазрешитьРедактированиеИспользованиеХарактеристик   = Истина;
	РазрешитьРедактированиеТипНоменклатуры              = Истина;
	РазрешитьРедактированиеИспользованияСерий           = Истина;
	РазрешитьРедактированиеВариантаОформленияУслуги     = Истина;
	РазрешитьРедактированиеАлкогольнаяПродукция         = Истина;
	РазрешитьРедактированиеСодержитДрагоценныеМатериалы = Истина;
	РазрешитьРедактированиеНастроекНабора               = Истина;
	РазрешитьРедактированиеВариантаЗаданияТоварныхКатегорий = Истина;
	РазрешитьРедактированиеЦенообразование              = Истина;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
